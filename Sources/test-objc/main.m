// Basic usage of whisper.cpp in Objective-C

#import "whisper.h"

#import <Foundation/Foundation.h>

#define CHECK(cond) \
    if (!(cond)) { \
        NSLog(@"[%s:%d] Check failed: %s\n", __FILE__, __LINE__, #cond); \
        exit(1); \
    }

#define CHECK_T(cond) CHECK(cond)
#define CHECK_F(cond) CHECK(!(cond))

int main(void) {
    // load the model (use correct path)
    struct whisper_context * ctx = whisper_init_from_file("models/for-tests-ggml-base.en.bin");
    CHECK_T(ctx != NULL);

    // run the model
    struct whisper_full_params params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY);

    params.print_realtime   = true;
    params.print_progress   = false;
    params.print_timestamps = true;
    params.print_special    = false;
    params.translate        = false;
    params.language         = "en";
    params.n_threads        = 4;
    params.offset_ms        = 0;

    const int n_samples = WHISPER_SAMPLE_RATE;
    float pcmf32[n_samples];

    // TODO: fill PCM with some audio

    if (whisper_full(ctx, params, pcmf32, n_samples) != 0) {
        NSLog(@"Failed to run the model");

        return -1;
    }

    // print the results
    const int n_segments = whisper_full_n_segments(ctx);

    for (int i = 0; i < n_segments; i++) {
        const char * text_cur = whisper_full_get_segment_text(ctx, i);

        NSLog(@"%s", text_cur);
    }

    // internal model timing
    whisper_print_timings(ctx);

    // free memory
    whisper_free(ctx);

    return 0;
}
