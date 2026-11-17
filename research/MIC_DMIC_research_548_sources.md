# Deep research: Acer SF514-53T / Whiskey Lake internal mic

Generated: 2026-11-18 00:52:56
- Calls: 39
- Raw items: 551
- Unique sources: 548
- Errors: 0

## Top-relevant sources

### 1. [score 12] labrouss/TGLDmic
- URL: https://github.com/labrouss/TGLDmic
- Channel: web
- Excerpt: TGLDmic       Tiger Lake & Comet Lake microphone driver for macOS  Internal digital microphones (DMIC) of Intel Tiger Lake and Comet Lake / Cannon Lake laptops (including ThinkPad X1 Carbon Gen 7) via the Intel Smart Sound DSP (SOF)   > [!NOTE] > **This fork is adapted for Comet Lake (CML) ThinkPad X1 Carbon Gen 7 (X1C7) from labrouss/TGLDmic.** It introduces cAVS 1.8 platform support, dynamic core power gating, dual embedded Intel production SOF v2.2 firmware (`sof-cml.ri` & `sof-tgl.ri`), dynamic input stream allocation, and 4-channel microphone routing modes.  > Unofficial community project. Not affiliated with or endorsed by Intel, Apple or any laptop vendor.  On modern Intel laptops (Ti

### 2. [score 12] GitHub - shubhambanekar/LatSOFAudio: Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls. · GitHub
- URL: https://ithub.global.ssl.fastly.net/shubhambanekar/LatSOFAudio
- Channel: web
- Excerpt: # LatSOFAudio  Internal microphone driver for the Intel SOF DSP on Comet Lake hackintosh laptops, tested on the Dell Latitude 3410 under macOS Sequoia.  Comet Lake laptops with PDM digital microphones (DMICs) have no working internal mic under macOS: the mics are wired to the Intel Smart Sound DSP (PCI `8086:02c8`), which Apple has no driver for, and on many boards (including this one, ALC236) the codec has no analog mic pin at all — so the headset jack cannot carry a mic either. This project boots the open SOF firmware (Sound Open Firmware, Intel's open-source DSP firmware) on that DSP, builds a DMIC capture pipeline, and publishes the result to macOS as a normal CoreAudio input device.  St

### 3. [score 12] GitHub - shubhambanekar/LatSOFAudio: Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls. · GitHub
- URL: https://safaia.net/shubhambanekar/LatSOFAudio
- Channel: web
- Excerpt: Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation,  ...  # LatSOFAudio  Internal microphone driver for the Intel SOF DSP on Comet Lake hackintosh laptops, tested on the Dell Latitude 3410 under macOS Sequoia.  Comet Lake laptops with PDM digital microphones (DMICs) have no working internal mic under macOS: the mics are wired to the Intel Smart Sound DSP (PCI `8086:02c8`), which Apple has no driver for, and on many boards (including this one, ALC236) the codec has no analog mic pin at all — so the headset j

### 4. [score 11] macintelk/LatSOFAudio
- URL: https://github.com/macintelk/LatSOFAudio
- Channel: web
- Excerpt: # macintelk/LatSOFAudio  Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls.  ...  # LatSOF-Audio — Sound Open Firmware (SOF) DMIC microphone driver for macOS  **Bring Intel Smart Sound Technology (SST / cAVS) digital microphones (DMIC) to macOS — as a real, native IOAudio input device.**  This is a single macOS kernel extension (kext) that implements, entirely in-kernel:  - an HDA controller companion for the Intel cAVS 1.8 DSP (Comet Lake), - the **Sound Open Firmware (SOF)** b

### 5. [score 10] GitHub - pokipoi/LatSOF-Audio: Sound Open Firmware (SOF) DMIC microphone driver for macOS — in-kernel cAVS DSP bring-up as a native IOAudio input. Comet Lake/ALC257 verified; generalizes to other cAVS laptops. Hackintosh, OpenCore, kext, MIT. · GitHub
- URL: https://safaia.net/pokipoi/LatSOF-Audio
- Channel: web
- Excerpt: GitHub - pokipoi/LatSOF-Audio: Sound Open Firmware (SOF) DMIC microphone driver for macOS — in-kernel cAVS DSP bring-up as a native IOAudio input. Comet Lake/ALC257 verified; generalizes to other cAVS laptops. Hackintosh, OpenCore, kext, MIT. · GitHub  ## About  Sound Open Firmware (SOF) DMIC microphone driver for macOS — in-kernel cAVS DSP bring-up as a native IOAudio input. Comet Lake/ALC257 verified; generalizes to other cAVS laptops. Hackintosh, OpenCore, kext, MIT.  ...  # LatSOF-Audio — Sound Open Firmware (SOF) DMIC microphone driver for macOS  Bring Intel Smart Sound Technology (SST / cAVS) digital microphones (DMIC) to macOS — as a real, native IOAudio input device.  This is a singl

### 6. [score 9] README.md
- URL: https://github.com/shubhambanekar/LatSOFAudio/blob/main/README.md
- Channel: web
- Excerpt: # LatSOFAudio  Internal microphone driver for the Intel SOF DSP on **Comet Lake** hackintosh laptops, tested on the **Dell Latitude 3410** under **macOS Sequoia**.  Comet Lake laptops with PDM digital microphones (DMICs) have no working internal mic under macOS: the mics are wired to the Intel Smart Sound DSP (PCI `8086:02c8`), which Apple has no driver for, and on many boards (including this one, ALC236) the codec has **no analog mic pin at all** — so the headset jack cannot carry a mic either. This project boots the open SOF firmware (Sound Open Firmware, Intel's open-source DSP firmware) on that DSP, builds a DMIC capture pipeline, and publishes the result to macOS as a normal CoreAudio i

### 7. [score 9] dmic · GitHub Topics · GitHub
- URL: https://github.com/topics/dmic
- Channel: web
- Excerpt: ### pokipoi / LatSOF-Audio   Sound Open Firmware (SOF) DMIC microphone driver for macOS — in-kernel cAVS DSP bring-up as a native IOAudio input. Comet Lake/ALC257 verified; generalizes to other cAVS laptops. Hackintosh, OpenCore, kext, MIT.  - Updated   Oct 2, 2026  ...  ### shubhambanekar / LatSOFAudio   Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls.  - Updated   Aug 2, 2026  ---

### 8. [score 9] sound-open-firmware · GitHub Topics · GitHub
- URL: https://github.com/topics/sound-open-firmware
- Channel: web
- Excerpt: ### pokipoi / LatSOF-Audio   Sound Open Firmware (SOF) DMIC microphone driver for macOS — in-kernel cAVS DSP bring-up as a native IOAudio input. Comet Lake/ALC257 verified; generalizes to other cAVS laptops. Hackintosh, OpenCore, kext, MIT.  ...  ### shubhambanekar / LatSOFAudio   Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls.  ---

### 9. [score 9] 七七黑苹果教程: 七七大老师自亲编写的OpenCore教程，有配套的视频可供观看
- URL: https://gitee.com/qiqidalaoshi_admin/qiqidalaoshi-OpenCore
- Channel: web
- Excerpt: # 七七的黑苹果安装教程 OpenCore配置 # **一，前言介绍** > 七七&laobamac 继续接手本教程 > 七七的黑苹果安装教程 OpenCore配置 配套视频教程 教程我也发在 B 站，感兴趣的网友可以自行去观看： **传送门：https://（为了避免网站查封，此处请删除并放置哔哩哔哩www.bili的bili.com网站）/video/BV1oT411L7f1** ## 配套的 QQ 群 建群的初衷不是请一帮伸手党大哥的，还是希望可以营造一个黑苹果技术讨论的地方，提问前自己先谷歌或者百度一下，别人也没有义务去帮你，虚心请教还是大家或多或少都会帮助的。 **七七的黑苹果正经交流（一群）（主打）：205490966 七七的黑苹果正经交流（二群）：316414289** 这个群可以制作EFI与定制USB接口，管理员也是有一定经验的 在群里我也会不定期发一些实用的软件供大家下载 ## 配套的微信群 应急专用 我也为大家考虑了很多，有些不适于使用QQ的我也会在以后的一定时间内开放微信群供大家讨论 # **二，基础知识** ## 1. 基操勿六 > 基础知识就是默认大家都懂的，如果不懂得话建议补一下基础再看此教程。 - 时间、稳定、版权 如果有项目要截止的话，请不要开始看这篇教程，因为刚开始黑苹果的过程基本上不会一帆风顺的，随便走一点弯路都是极其耗费时间的事情，另外注意休息，黑苹果的过程不差你熬夜的那几个小时。 如果你对系统要求追求稳定的话，也尽量不要使用黑苹果，虽然黑苹果完美度已经无限接近白苹果了，但是毕竟还是有个“黑”字，安装的时候要注意重要资料备份。 如果你的公司

### 10. [score 9] sof · GitHub Topics · GitHub
- URL: https://github.com/topics/sof
- Channel: web
- Excerpt: ### pokipoi / LatSOF-Audio   Sound Open Firmware (SOF) DMIC microphone driver for macOS — in-kernel cAVS DSP bring-up as a native IOAudio input. Comet Lake/ALC257 verified; generalizes to other cAVS laptops. Hackintosh, OpenCore, kext, MIT.  ...  ### shubhambanekar / LatSOFAudio   Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls.  ---

### 11. [score 8] Tiger Lake, Hackintosh, Digital Microphone Driver : r/hackintosh
- URL: https://www.reddit.com/r/hackintosh/comments/1xjdi5a/tiger_lake_hackintosh_digital_microphone_driver/
- Date: 2026-10-30T12:03:26.000Z
- Channel: web
- Excerpt: During my Tiger Lake hackintosh adventures, i realized that my laptop has a digital microphone and i've found no solution available. So why not develop a kext for that.  **https://github.com/labrouss/TGLDmic**  **Tiger Lake microphone driver for macOS**  Internal digital microphones (DMIC) of Intel Tiger Lake laptops via the Intel Smart Sound DSP (SOF)  >Unofficial community project. Not affiliated with or endorsed by Intel, Apple or any laptop vendor.  On many Tiger Lake laptops the built-in microphones are not wired to the HDA codec but to the Smart Sound DSP, so AppleALC cannot make them work and hackintoshes end up without an internal mic. TGLDmic boots Intel's SOF firmware on that DSP a

### 12. [score 8] cjtim/SF314-55G-hackintosh
- URL: https://github.com/cjtim/SF314-55G-hackintosh
- Channel: web
- Excerpt: # cjtim/SF314-55G-hackintosh  Acer swift 2019 SF314-55G hackintosh  ...  ## README    # Acer Swift 3 2019 SF314-55G Hackintosh  For Mojave Clover (discontinued) -> Mojave-clover branch  **Status: ✅ Daily usable**  This EFI aiming to config mostly DSDT patch and try to not install kext if possible.  ## Known working version * Catalina - 10.15.7 * Big Sur - 11.6.1  ...  - Spec - Working ✅ - Not working ❌ - Installation 🍱  ...  ### Spec  - I5-8562U Whiskey lake - UHD 620 - Nvidia MX250 - ALC256 - WD SSD 512GB - 2 USB3 - 1 USB-C with PD charging and Display port compatibility - Intel(R) Wireless-AC 9560  ### Working ✅  **Everythings is working.**  | Feature | Note | |--|--| | Sound 🔊 | ✅ Speaker

### 13. [score 8] OctoDevStudios/MateBookAudio
- URL: https://github.com/OctoDevStudios/MateBookAudio
- Channel: web
- Excerpt: # MateBookAudio  macOS audio driver for laptops using **Intel Sound Open Firmware (SOF) + Everest ES8336** — built for the Huawei MateBook D15 2020 (Comet Lake, board BOHB-WAX9).  These machines have no HDA codec: audio goes through the Intel cAVS DSP and an I2S codec on I2C. AppleALC cannot drive that, so Hackintosh users usually fall back to USB or Bluetooth audio. MateBookAudio drives the whole path itself:  | | | |---|---| | Speakers | ✅ with a measured EQ / virtual bass / limiter DSP | | Headphones (hot-plug) | ✅ shown as *Headphones* in Sound settings | | Internal microphone (DMIC) | ✅ | | Headset microphone | ✅ shown as *External Microphone* when a 4-pole headset is plugged in | | Vol

### 14. [score 8] AppleALC - Need help on custom layout for ALC255 - New Users Lounge | InsanelyMac
- URL: https://www.insanelymac.com/forum/topic/355448-applealc-need-help-on-custom-layout-for-alc255/
- Date: 2023-01-22T14:49:44.000Z
- Channel: web
- Excerpt: hello, i recently made a custom layout for my laptop (layout=69 in ALC255) and it got merged into the main repo. i had an annoying issue with my layout (headsets produced white noise when the power state changed from AC to BAT), but i recently fixed it with new ConfigData and i will make a new pull request to main repo.    now i have another strange problem. after the computer sleeps and wakes up, when the internal microphone (node 0x12) is used and after it enters sleep state, headsets (node 0x19) no longer produce sound after some time. i need to unplug and then plug headsets back in order to get working sound. they continue to work even if internal microphone enters sleep state after unpl

### 15. [score 8] intel-sst · GitHub Topics · GitHub
- URL: https://github.com/topics/intel-sst
- Channel: web
- Excerpt: ### shubhambanekar / LatSOFAudio   Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls.  ...  ### Goldmanitu / acer-swift-sf314-54g-linux-mic-fix   Fix for silent internal DMIC on Acer Swift SF314-54G (ALC256 / Intel SST AVS) on Linux, Zorin/Ubuntu, PipeWire, Brave and Chrome).  - Updated   Oct 5, 2026 - Shell  ---

### 16. [score 8] 2026年黑苹果声卡驱动深度指南：AppleALC进阶配置与常见问题全面解析 – 悠哉网
- URL: https://www.yoozai.com/22368.html
- Date: 2026-04-28T00:00:00.000Z
- Channel: web
- Excerpt: 2026-04-28资讯 0 0 6 0  声卡驱动是黑苹果配置中最令人头疼的问题之一，也是很多用户在安装完macOS后遇到的第一个硬件兼容性难题。AppleALC是目前最主流的黑苹果声卡驱动解决方案，通过内核扩展（Kext）方式将主流笔记本和台式机主板的内置声卡适配为macOS原生音频框架。本文将从AppleALC的工作原理出发，详细介绍2026年最新版本的配置方法，以及常见问题的排查与解决思路。  ## 一、AppleALC工作原理与版本选择  AppleALC的核心机制是通过`layout-id`（布局ID）参数告诉驱动程序如何映射声卡的输入输出路径。每个声卡型号（Codec）对应多个由社区贡献者制作的layout，不同layout适配不同的主板和音频接口组合。AppleALC目前支持超过400种Codec，覆盖了Realtek、Intel、Cirrus Logic等主流声卡芯片组。在选择AppleALC版本时，建议始终使用与OpenCore同一天发布的Release版本，避免因版本不匹配导致的稳定性问题。  确定声卡Codec型号是配置的第一步。在Windows下，可以通过设备管理器查看声音控制器的硬件ID，或使用CPU-Z等工具查看主板芯片组信息。常见的台式机Codec包括ALC887、ALC897、ALC1220等，高端主板通常搭配ALC1220或ALC4080。笔记本声卡则更加多样，除了Realtek系列外，还有Intel SST（Smart Sound Technology）和Cirrus Logic CS8409等型号需要特殊处理。确认Codec型号后，在Ap

### 17. [score 8] intel-sst · GitHub Topics · GitHub
- URL: https://github.com/topics/intel-sst?l=c
- Channel: web
- Excerpt: ### shubhambanekar / LatSOFAudio   Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls.  ---

### 18. [score 8] alc236 · GitHub Topics · GitHub
- URL: https://github.com/topics/alc236?l=c
- Channel: web
- Excerpt: ### shubhambanekar / LatSOFAudio   Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls.  ---

### 19. [score 8] dell-latitude-3410 · GitHub Topics · GitHub
- URL: https://github.com/topics/dell-latitude-3410?l=c
- Channel: web
- Excerpt: ### shubhambanekar / LatSOFAudio   Internal mic / microphone driver for the Dell Latitude 3410 Hackintosh — macOS Sequoia, OpenCore, Comet Lake, Realtek ALC236. Boots Sound Open Firmware (SOF) on the Intel Smart Sound (SST) DSP so the built-in DMIC works in Siri, Dictation, FaceTime and browser calls.  ---

### 20. [score 7] README.md
- URL: https://github.com/tarekwasfy01/HP-250-G10-OpenCore-Tahoe/blob/main/README.md
- Channel: web
- Excerpt: # HP 250 G10 — macOS Tahoe, Iris Xe and internal microphone  Working reference for an **HP 250 G10 / Core i5-1334U**, updated **15 November 2026**. The owner confirmed desktop startup and **audible capture from the built-in microphone** with the included HP250Dmic build. The working OCTEST EFI was copied to TAHOE-BOOT; 95 source files were verified. A post-copy TAHOE-BOOT boot test remains separate.  ...  | Graphics / panel | Iris Xe 8086:A7A1 rev 04, 80 EUs / 1920 × 1080 internal panel | | Audio | Intel 8086:51CA, subsystem 103C:8B34 / Realtek ALC236 | | Internal microphone | Two digital microphones through Intel SOF/SST |  ...  ### 4. Install the microphone CoreAudio plug-in  Both pieces a

### 21. [score 7] aidanchandra/x1c7-hackintosh
- URL: https://github.com/aidanchandra/x1c7-hackintosh
- Channel: web
- Excerpt: # macOS on Thinkpad X1 Carbon 7th Generation OpenCore-based Hackintosh EFI and guide for Lenovo Thinkpad X1 Carbon Gen 7. This guide has been generated for both the model numbers specified below.           # Usage **This OpenCore config comes with empty PlatformInfo / SMBIOS!**  Follow **Dortania's OpenCore Install Guide** to generate your own: **Laptop** Coffee Lake and Whiskey Lake > Platforminfo. If you own a Lenovo 20R1 (Intel 10th gen) also note the hint at Hardware Compatability    # Overview ## Summary  This X1C7 Hackintosh project aims to be an all-in-one maintained hub for Opencore-based hackintoshes on the Thinkad X1 Carbon Gen 7. In short, this x1c7-hackintosh is very stable and i

### 22. [score 7] suhrmann/x1c7-hackintosh
- URL: https://github.com/suhrmann/x1c7-hackintosh
- Channel: web
- Excerpt: # macOS on Thinkpad X1 Carbon 7th Generation, Model 20QE\*   ➡️ The latest OpenCore config for X1C7 is aidanchandra / x1c7-hackintosh   Aidan Chandra @aidanchandra and I created a almost fully working HackBookPro.  ...  **Note:** I did not update most of the docs (for X1C7 / X1 Carbon 7th Gen) _yet_ 🙄  ...  | working | Device / Step | Comment | |:-------:|:------------------------------------------|:-------------------| | ☑️ | **Basic Setup** | Working base config in ``EFI-install_USB``, see release EFI-install_USB | | ✅ | Booting Clover Bootloader | | | ✅ | Booting macOS installer | | | ✅ | Installed to HD | | | | **Post-Install** | | | ✅ | Graphics | Working in ``EFI-install_USB`` ⚠️ ToDo:

### 23. [score 7] Add ALC298 layout-id 98 for Lenovo Yoga 9 15IMH5
- URL: https://github.com/acidanthera/AppleALC/pull/955
- Channel: web
- Excerpt: Add ALC298 layout-id 98 for Lenovo Yoga 9 15IMH5  **Codec:** Realtek ALC298 **Layout-ID:** 98 **Machine:** Lenovo Yoga 9 15IMH5 (82DE) **Subsystem ID:** 0x17AA3822  **Working:** - Internal speakers (Pin 0x14 → DAC 0x03) - Headphones with auto-switching (Pin 0x21 → DAC 0x02) - External microphone / headset mic (Pin 0x18 → ADC 0x08)  **Not working:** - Internal microphone (DMIC via Intel SST/SOF, not routed through ALC298 HDA codec)  **Pin Configurations:** | Pin | Config | Device | |-----|--------|--------| | 0x12 | 0x90A60180 | Fixed Mic In at Int (internal mic pin) | | 0x14 | 0x90170140 | Fixed Speaker at Int | | 0x18 | 0x04A11020 | Jack Mic at Ext Right (headset mic) | | 0x21 | 0x04211010 

### 24. [score 7] velickovicdj/A315-54K-34P6-OpenCore
- URL: https://github.com/velickovicdj/A315-54K-34P6-OpenCore
- Date: 2021-02-03T22:41:18.000Z
- Channel: web
- Excerpt: # A315-54K-34P6 OpenCore Hackintosh  Status OpenCore macOS  :warning: **WARNING:** This OpenCore configuration is optimized for my specific hardware, so please read carefully before doing anything or use it only as a reference. I suggest you to refer to Dortania for anything else.          ## Hardware  |**Category**|**Component** |**Note** | |------------|-------------------------------------|-----------------------------------------------| |**CPU** |2.3GHz Intel Core i3-7020U | | |**iGPU** |Intel HD Graphics 620 | | |**RAM** |12GB (4GB non-removable) 2133MHz DDR4|Replaced the original 4GB with a new 8GB stick.| |**SSD** |256GB M.2 PCIe NVMe SSD | | |**Display** |15,6" 1080p LCD non-touch di

### 25. [score 7] ALC295 - Acer Nitro 5 - Continuous hissing noise with 3.5 combojack headphones - AppleALC | InsanelyMac
- URL: https://www.insanelymac.com/forum/topic/359119-alc295-acer-nitro-5-continuous-hissing-noise-with-35-combojack-headphones/
- Date: 2024-04-03T19:24:37.000Z
- Channel: web
- Excerpt: Hello! I am currently finishing to setup my first hackintosh on my Acer Nitro 5 AN515-55-51QY laptop and I am stuck on the last thing : configuring properly the audio. My codec is ALC295. For the setup I am using OpenCore 0.9.8 and macOS Sonoma 14.3.1, and the AppleALC kext V.1.8.9 . The issue is that, with the best working layout-ids (13 and 77) for my config, when I plug my HyperX Cloud II single jack headset to my laptop I get a continuous high-pitched hissing/static noise. When no audio is played I only hear that noise, otherwise I still can hear it in the background and it's giving me a headache. The headsets microphone is also not detected but the internal speakers and microphone are w

### 26. [score 7] docs/macos-mic-troubleshooting.md
- URL: https://github.com/MYunFeiYang/zbookpowerg7/blob/main/docs/macos-mic-troubleshooting.md
- Channel: web
- Excerpt: ## 定论（可直接引用）  | 项目 | 结论 | |------|------| | **内置麦克风** | **不支持**（Hackintosh / macOS 下无法使用） | | **原因** | 内置麦为 **Intel SST / SoundWire 数字麦克风**，不经 Realtek ALC236 模拟通路；macOS **无** Intel SST 驱动 | | **macOS 实测** | 系统设置 → 声音 → 输入 有「内置麦克风」，**输入电平始终无信号**（未插耳机、音量正常，对着麦说话电平不跳） | | **AppleALC / layout** | 仅服务 **扬声器、3.5mm 耳机/线路**；**不能**修复内置数字麦 | | **`SSDT-SNDW-off`** | 已验证**不能**使内置麦可用；保留与否只影响 SNDW 设备暴露，**以播放是否正常为准** | | **可行输入** | **USB 麦**、**蓝牙麦**；**3.5mm 耳麦**走 ALC236 模拟通路，需正确 `layout-id`（见下文） | | **耳机孔麦** | **`layout 55` 可用**：插 TRRS 耳麦、手动选 **「线路输入」** 有电平；**不会自动切换**输入设备 |  **停止排查内置麦**：勿再为**内置数字麦**轮换 layout 或追加 ACPI。耳机孔麦可单独调 layout。  ...  ### Windows 上的路径  ``` Intel SST 控制器 (8086:06C8) ├── LINKTYPE_02 → R

### 27. [score 7] BluePurplePro/HP-Envy-13-AQ0026TU-Hackintosh
- URL: https://github.com/BluePurplePro/HP-Envy-13-AQ0026TU-Hackintosh
- Channel: web
- Excerpt: OpenCore Bootloader EFI files needed to boot macOS successfully on the HP Envy13-AQ0026TU  ...  # HP Envy13-AQ0026TU Hackintosh This repository and project hosts the files necessary to boot macOS Ventura successfully on the HP Envy13-AQ0026TU Laptop  # DISCLAIMER THIS INFORMATION/RESEARCH HAS BEEN DONE AND SHARED PURELY FOR EXPERIMENTAL AND RESEARCH PURPOSES, AND IS IN NO MAY MEANT TO PROMOTE CIRCUMVENTING OF ANYTHING THAT IS SOMEONE ELSE'S CORPORATE PRIVATE PROPERTY. THE INFORMATION LISTED HERE IS PURELY FOR EDUCATIONAL PURPOSES AND SHOULD YOU CHOOSE TO UTILIZE IT IN ANY WAY, I AM IN NO WAY RESPONSIBLE FOR ANY INJUNCTIONS/PROBLEMS THAT MAY OR MAY NOT ARISE AND/OR BE BROUGHT AGAINST ANOTHER 

### 28. [score 7] GUIDE - How to Enable Audio on macOS [Clover/OpenCore] | EliteMacx86 Forum
- URL: https://elitemacx86.com/threads/how-to-enable-audio-on-macos-clover-opencore.99/
- Date: 2018-08-20T18:03:59.000Z
- Channel: web
- Excerpt: Audio is an integral part of a computer and needs to be enabled. Normally, the Audio Codecs found on Non-Apple computers do not work OOTB when using OS X/macOS, unless its an USB Audio device. VoodooHDA was being used for a long time to enable the Audio on macOS. However, VoodooHDA was not the perfect solution for Audio and it had problems such as stuttering, and a low level of audio volume as compared to Windows/Linux. Some other methods include patching AppleHDA. With the introduction of AppleALC, it was much easier to enable Audio on OS X/macOS. AppleALC is one of the easiest methods to enable native audio without modifying the original AppleHDA. There are several other methods but this s

### 29. [score 7] AMDMicrophone.kext v1.0.0 AMD笔记本走集成显卡麦克风声卡驱动,AMD声卡驱动 - 黑苹果屋
- URL: https://imacos.top/2024/07/29/amdmicrophone-kext-v1-0-0-amd/
- Date: 2024-07-29T00:00:00.000Z
- Channel: web
- Excerpt: # AMDMicrophone.kext v1.0.0 AMD笔记本走集成显卡麦克风声卡驱动,AMD声卡驱动   imacos.top 2024-07-29 声卡驱动 1.05k 19 推广   ## 简介  AMDMicrophone.kext是一款AMD笔记本走集成显卡麦克风声卡驱动,适用于配备AMD音频协处理器（ACP）的现代AMD笔记本电脑的AMD数字麦克风kext。   ### 这个kext是做什么的？  在一些现代AMD笔记本电脑中，麦克风不再连接到高清音频总线。它们现在由专用的音频协处理器控制，因此macOS中显然没有驱动程序。这个kext为他们带来了支持。有关更多信息，请参阅常见问题解答。  ### 什么在起作用？  - 雷诺阿基础笔记本电脑的麦克风，带数字麦克风（又名基于ACP的麦克风）。  ### 什么不起作用？  - 除了雷诺阿之外的其他CPU变体，如Raven/Raven2/Fire Flight/Van Gogh/Yellow Carp。如果您想支持这些设备，请打开问题。  ### 先决条件  #### 检查您的笔记本电脑是否配备了基于ACP的麦克风  #### 窗口  确保您有一个可以正常工作的麦克风阵列设备。  #### Linux  确保默认源设备是ACP  ``` $ pactl get-default-source | grep acp alsa_input.pci-0000_03_00.6.HiFi__hw_acp__source ```  ### 更新csr-active-config  此kext依赖于`com.apple.iokit

### 30. [score 7] anerik70/Asus-Zenbook-13-UM325U
- URL: https://github.com/anerik70/Asus-Zenbook-13-UM325U
- Date: 2023-09-15T21:34:31.000Z
- Channel: web
- Excerpt: - **OpenCore 1.0.8**, SMBIOS `MacBookPro16,2` - **Lilu 1.7.1** - **NootedRed 0.9.0** (iGPU acceleration, Metal works) - **AirportItlwm 2.4.1** (Wi-Fi; no OCLP root patches — they were reverted and are not used) - **AppleALC 1.9.5 + SimpleHDA**, layout `alcid=44` - **Custom USB map** built in Tahoe with corpnewt/USBMap (controllers XHC0 + XHC2; camera and Bluetooth ports marked internal, connector 255) - **Intel Bluetooth**: IntelBluetoothFirmware + IntelBTPatcher 2.5.2 (lshbluesky fork) + BlueToolFixup 2.7.2 - **AuxDim 0.3.0** — OLED brightness through the AMD AUX interface (details below) - **AMDMicrophone** for the internal mic (installed in /Library/Extensions)  Production boot-args:  ```

### 31. [score 6] Support DMIC (Intel SST)
- URL: https://github.com/acidanthera/bugtracker/issues/2084
- Channel: web
- Excerpt: # Support DMIC (Intel SST)  - State: open - Author: Lorys89 - Created: 2022-07-13T11:23:03Z - Updated: 2023-03-13T02:36:51Z - Repository: acidanthera/bugtracker - Number: #2084 - Assignees: vit9696  ## Labels  - enhancement - help wanted  ---  hi everyone, hi @vit9696 I was wondering seen the numerous notebooks that mount dmic array intel sst if it is possible to implement this code on apple alc or create a new kext.  I viewed these parts that I link on linux drivers :  https://github.com/torvalds/linux/blob/master/sound/soc/intel/boards/sof_sdw_dmic.c  https://github.com/torvalds/linux/blob/master/sound/soc/intel/boards/sof_sdw.c    cc @vandroiy2013  ...  **vit9696** commented on 2022-08-01

### 32. [score 6] Thinkpad X1 Carbon Gen 7 in-built mic? : r/hackintosh
- URL: https://www.reddit.com/r/hackintosh/comments/rzcw6a/thinkpad_x1_carbon_gen_7_inbuilt_mic/
- Date: 2022-01-08T23:12:00.000Z
- Channel: web
- Excerpt: So, first and foremost, it isn't a bad layout ID or Intel Smart Sound Technology. I've tried all layout IDs for ALC285, and I booted into Linux to test the microphone (Linux has no support for SST) and it works perfectly.  So... yeah. I'm on a Thinkpad X1 Carbon Gen 7. I don't know what hardware I should list, so just comment if you need to know anything!  ...  **u/Seven_of_eleven** · 1 point · January 9, 2022 at 1:45 AM UTC > I have the same laptop running BigSur 11.2.3 github repo. I never got the mic to work. I either plugged in headphones (with a mic) or used a small USB mic. I'm planning to update OpenCore and MacOS next week. Let me know if you manage to get the mic working please.  --

### 33. [score 6] WhatUpGit/x1c7-hackintosh
- URL: https://github.com/WhatUpGit/x1c7-hackintosh
- Channel: web
- Excerpt: | working | Device / Step | Comment | |:-------:|:------------------------------------------|:-------------------| | ☑️ | **Basic Setup** | Working base config in ``EFI-install_USB``, see release EFI-install_USB | | ✅ | Booting Clover Bootloader | | | ✅ | Booting macOS installer | | | ✅ | Installed to HD | | | | **Post-Install** | | | ✅ | Graphics | Working in ``EFI-install_USB`` ⚠️ ToDo: Fix HiDPI (I have 1080p display, so for me low prio) | | ✅ | Touchpad | Requires ``VoodooI2C`` with ``XOSI`` ACPI patch| | ✅ | Trackpoint | Requires ``VoodooPS2`` | | ✅ | Keyboard | Requires ``VoodooPS2`` | | ❌ | Keyboard-Multimedia Fn keys | Partially - need ACPI for ThinkpadAssistant | | ✅ | WiFi | With `

### 34. [score 6] WhatUpGit/x1c7-hackintosh2
- URL: https://github.com/WhatUpGit/x1c7-hackintosh2
- Channel: web
- Excerpt: | working | Device / Step | Comment | |:-------:|:------------------------------------------|:-------------------| | ✅ | Graphics | Requires `WhateverGreen.kext` | | ✅ | Touchpad | Requires ``VoodooGPIO, VoodooI2CServices,VoodooInput`` This was very trial-and-error based and I reccomend looking at our config.plist. Order and location matter. | | ✅ | Trackpoint | Requires ``VoodooPS2`` | | ✅ | Keyboard | Requires ``VoodooPS2`` | | ✅ | Keyboard-Multimedia Fn keys | Requires `YogaSMC.kext` + **TODO: Add ACPI here** and YogaSMC-App | | ✅ | WiFi | Native WiFi with `AirportItlwm.kext` - no companion app required | | ✅ | Bluetooth | `IntelBluetoothFirmware.kext` and `IntelBluetoothInjector.kext` ⚠️

### 35. [score 6] SOF Audio - General Discussion | InsanelyMac
- URL: https://www.insanelymac.com/forum/topic/363389-sof-audio/
- Date: 2026-11-02T04:42:43.000Z
- Channel: web
- Excerpt: # SOF Audio    By jalavoui, November 2 in General Discussion    jalavoui Posted November 2    jalavoui    Posted November 2 (edited)    based on https://github.com/pokipoi/LatSOF-Audio    firmware from https://thesofproject.github.io/latest/release.html    working driver in tahoe for dmic + AppleHDA for intel 0xa0c8       this is a possible list   ```html static const XePlat kXePlatTable[] = {     // cAVS 1.5     {0x5A988086u, XE_GEN_15,     0,          "APL",     "sof-apl.ri"},     {0x1A988086u, XE_GEN_15,     0,          "BXT-T",   "sof-apl.ri"},     {0x31988086u, XE_GEN_15,     0,          "GLK",     "sof-glk.ri"},     // cAVS 1.8     {0x9DC88086u, XE_GEN_18,     0,          "CNL",     "s

### 36. [score 6] ioaudio · GitHub Topics · GitHub
- URL: https://safaia.net/topics/ioaudio
- Channel: web
- Excerpt: · GitHub  ### pokipoi / LatSOF-Audio   Sound Open Firmware (SOF) DMIC microphone driver for macOS — in-kernel cAVS DSP bring-up as a native IOAudio input. Comet Lake/ALC257 verified; generalizes to other cAVS laptops. Hackintosh, OpenCore, kext, MIT.  ---

### 37. [score 6] longnguyen245/Ryzentosh-Acer-aspire-7-A715-42G-Opencore-EFI
- URL: https://github.com/long5436/Ryzentosh-Acer-aspire-7-A715-42G-Opencore-EFI
- Channel: web
- Excerpt: # Laptop Acer Aspire 7 Gaming alt tag  Supported - Aspire 7 A715-42G-R6ZR - Aspire 7 A715-42G-R05G - Aspire 7 A715-42G-R4ST - Aspire 7 A715-42G-R4XX (Some machines with this code may have problems booting)  ## SYSTEM INFOMATION  | | | | ----------------- | ------------------------------ | | Processor: | AMD Ryzen 5 5500U (APU Mobile) | | Memory: | 8GB x 2 | | Graphics: | AMD Radeon RX Vega 7 (Renoir) | | Wireless Network: | Intel AX210 | | Strorage: | WD SN530 | | Audio: | Realtek ALC255 | | Camera: | HD User Facing |  ...  ## Installation Instructions  1. Setup bios: Disable fast boot, disable secure boot 2. Disabled kext "NootedRed.kext", after the setup process after installing MacOS and 

### 38. [score 6] AppleALC - Need help on custom layout for ALC255 - Page 2 - New Users Lounge | InsanelyMac
- URL: https://www.insanelymac.com/forum/topic/355448-applealc-need-help-on-custom-layout-for-alc255/page/2/
- Date: 2023-01-22T14:49:44.000Z
- Channel: web
- Excerpt: @iwissem, Have you tried completely disabling the internal microphone?  ...  I am one of VoodooHDA developers and I am deep in HDA theory. It is impossible to have internal and external microphone an line-in working together without breaking HDA standard.    VoodooHDA does this.  ...  The headsets mic is not a problem anymore using the layout 33, it is perfectly well detected and automatically switch to it from internal. As soon as i plug the combojack the headset mic is working unlike all my previous attempts. I just tested it its due to the pin 0x19's configdata. Only remains the issue of the still noise i have on the headsets output.    Any idea on what can cause that high pitched continu

### 39. [score 6] Lorys89/DELL_VOSTRO_5490
- URL: https://github.com/Lorys89/DELL_VOSTRO_5490
- Date: 2022-08-31T08:46:04.000Z
- Channel: web
- Excerpt: # Dell Vostro 5490 (Comet Lake U) Hackintosh  [![](https://img.shields.io/badge/EFI-Release-informational?style=flat&logo=apple&logoColor=white&color=9debeb)](https://github.com/Lorys89/DELL_VOSTRO_5490/releases)  EFI for Dell Vostro 5490 with OpenCore bootloader  ![descrizione](./Screenshot/pc.png)  ### Computer Spec:  | Component | Brank | | --- | --- | | CPU | Intel i7 10510U (4C-8T 8MB CML-U) | | iGPU | Intel® UHD Graphics | | DGPU. | Nvidia MX250 2GB GDDR5 | | Lan | Realtek 8168 | | Audio | Realtek ALC236 | | Ram | 16 GB DDR4 2667 Mhz | | Wifi + Bluetooth | BCM94352Z (DW1560) | | NVMe | Koxia KBG40ZNS512G 512 GB (MACOS) | | SSD SATA | Silicon Power A55 256 GB (WIN 11) | | SmBios | MacBo

### 40. [score 6] [Guide] Acer Swift 5 SF514-53t whiskey lake MacOS10.14.5
- URL: https://www.tonymacx86.com/threads/guide-acer-swift-5-sf514-53t-whiskey-lake-macos10-14-5.277618/
- Date: 2019-05-21T14:33:34.000Z
- Channel: web
- Excerpt: # [Guide] Acer Swift 5 SF514-53t whiskey lake MacOS10.14.5  - Start date May 21, 2019 - Thread starter richardchiu  Status Not open for further replies.  #### richardchiu  Joined Jul 23, 2015 Messages 75 Motherboard Acer Swift 5 SF514-53t CPU i5-8265U Graphics UHD 620 Mac  Mobile Phone  I'm glad that I make it! I w'd like to share with you. Laptop Acer Swift 5 SF514-53t CPU Core i5-8265U weight 970gm Intel® UHD Graphics 620 M.2 SSD 512G DDR4 2400 16 G What Works  - Continuity and Hand-off - WiFi and Bluetooth - Webcam - Touchscreen and Trackpad(elan0501) with Gestures - Keyboard - Headphone Jack/Combo Jack (headphone / headset(w/mic) support) - Audio ALC255 - Type-c to DP with Audio (2k, 4k 

### 41. [score 6] yes-man-Guo/Lenovo-Legion-Y9000X-IAH7---hackintosh
- URL: https://github.com/yes-man-Guo/Lenovo-Legion-Y9000X-IAH7---hackintosh
- Channel: web
- Excerpt: # Lenovo Legion Y9000X 2022 (IAH7) Hackintosh  Lenovo Legion Y9000X 2022 的 OpenCore 黑苹果工程与排查记录。  - **机型**：i5-12500H (Alder Lake-P) + RTX 3050 Ti Laptop + AX211 Wi-Fi/BT - **系统**：macOS 15.8 Sequoia，OpenCore（AAPL debug 版） - **图形**：NullMoth/NVRM 社区驱动（NVRM/NVAccel/NVRMAGDC/NVRMFB）直驱内屏，H.264/HEVC 硬编硬解全通  ## 当前状态（2026-11-11）  | 部件 | 状态 | 方案 | |---|---|---| | GPU 加速 | ✅ | NVRM 2.9 社区驱动（`/Library/Extensions`）+ AMFIPass | | 扬声器 | ✅ | ALC287 (alcid=13) + CS35L41 I2C 功放，SSDT-CSPK `RPST` AML 复位脉冲 + CirrusAudioFixup + VoodooGPIO | | Wi-Fi | ✅ | itlwm + HeliPort | | 蓝牙 | ✅ | AX211 (8087:0033, BlazarU) 需要 IntelBluetoothFirmware v2.5.3 的 ibt-0093-0041 固件 | | 触摸板 | ✅ | VoodooI2C fork（ADL-P personality + Tran

### 42. [score 6] README.md
- URL: https://github.com/DexterSLamb/KblAVSAudio/blob/main/README.md
- Channel: web
- Excerpt: # KblAVSAudio  A macOS audio driver for the **Google Pixelbook Go** (codename *Atlas*, Intel Amber/Kaby Lake-Y) running as a Hackintosh. It drives the machine's Intel **AVS** (Audio DSP, the pre-SOF cAVS 1.5 generation) directly over IPC4, plus its I²C codecs — there is no vendor macOS driver for this hardware, so it was written from scratch, porting the register and IPC4 sequences from the open-source Linux AVS stack (and building on the sibling CmlSOFAudio platform skeleton).  > ⚠️ **Experimental / community project.** This is an unofficial driver for > unofficial (Hackintosh) macOS installs. It is not affiliated with Apple, Intel, > Google, Maxim, Dialog, or the AVS/SOF projects. Use at y

### 43. [score 6] GitHub - DexterSLamb/KblAVSAudio: macOS (Hackintosh) audio driver for the Google Pixelbook Go — Intel AVS DSP over IPC4, MAX98373 speakers, DA7219 headphone with jack hot-swap, DMIC mic. · GitHub
- URL: https://ithub.global.ssl.fastly.net/DexterSLamb/KblAVSAudio
- Channel: web
- Excerpt: # KblAVSAudio  A macOS audio driver for the Google Pixelbook Go (codename Atlas, Intel Amber/Kaby Lake-Y) running as a Hackintosh. It drives the machine's Intel AVS (Audio DSP, the pre-SOF cAVS 1.5 generation) directly over IPC4, plus its I²C codecs — there is no vendor macOS driver for this hardware, so it was written from scratch, porting the register and IPC4 sequences from the open-source Linux AVS stack (and building on the sibling CmlSOFAudio platform skeleton).  > ⚠️ >  > Experimental / community project. This is an unofficial driver for unofficial (Hackintosh) macOS installs. It is not affiliated with Apple, Intel, Google, Maxim, Dialog, or the AVS/SOF projects. Use at your own risk.

### 44. [score 6] DexterSLamb/CmlSOFAudio
- URL: https://github.com/DexterSLamb/CmlSOFAudio
- Channel: web
- Excerpt: # CmlSOFAudio  A macOS audio driver for the **HP Chromebook C1030** (codename *Jinlon*, Intel Comet Lake) running as a Hackintosh. It drives the machine's Intel **SOF** (Sound Open Firmware) audio DSP and its codecs directly — there is no vendor macOS driver for this hardware, so it was written from scratch, porting the register and SOF IPC sequences from the open-source Linux SOF stack.  > ⚠️ **Experimental / community project.** This is an unofficial driver for > unofficial (Hackintosh) macOS installs. It is not affiliated with Apple, Intel, > HP, or the SOF project. Use at your own risk.  ## What works  - 🔊 **Speaker** (MAX98357A, SSP1) - 🎧 **Headphone** (RT5682, SSP0) with **jack hot-swa

### 45. [score 6] [GUIDE] How to Activate Microphone on Conexant Codecs and others. - Page 3 - Guides and Tutorials - Hackintosh Olarila
- URL: https://olarila.com/topic/5586-guide-how-to-activate-microphone-on-conexant-codecs-and-others/page/3/
- Date: 2018-12-08T18:05:40.000Z
- Channel: web
- Excerpt: Hi.   Jack FIX working with my Acer and ALC255 Codec.   My Problem was the Distorted Audio through Headphones. Jack_FIX fixed every time I execute it .   I make Jack-Fix Autostart at Start with Mojave but I must every Time start Jack_Fix in Terminal as Admin.   I using Mojave 10.14.4   Is there a way it can Autostart the Fix or integrate the Fix to AppleALC or Clover?   Thank you so much  ...  Hello,   I've got Conexant Unknown (Generic), but with AppleALC and codec 3 audio on jack and speakers works. There's a problem with internal microphone and combojack microphone. Can you help me with Jack_Fix for that?  ...  My vendor id is exactly the same as Conexant CX8050, so we can suppose that th

### 46. [score 6] armzyaec/Acer-Aspire-7-A715-42G-Hackintosh-
- URL: https://github.com/armzyaec/Acer-Aspire-7-A715-42G-Hackintosh-
- Date: 2023-11-24T08:01:21.000Z
- Channel: web
- Excerpt: ## Specifications  | Item | Info | | --- | --- | | Model | Acer Aspire 7 A715-42G | | CPU | AMD Ryzen™ 5 5500U Processor | | DGPU | Nvidia Geforce GTX 1650 4GB | | RAM 1 | Hynix DDR4 8GB 3200 MHz | | RAM 2 | TRANSCEND DDR4 8GB 3200 MHz | | Disk | WD Black SN770 1TB (Run on PciGen3) | | WIFI | Intel® Wi-Fi 6E AX200 160Mhz | | Bluetooth | With Intel combo card | | Ethernet | Realtek RTL8111 | | Audio | Realtek ALC255 | | LCD Panel | 15.6 FHD IPS 144Hz | | Opencore Version | 0.9.4 | | SMBIOS used | MacBookPro16,3 (Need to enter your information generated by [GenSMBIOS](http://https://github.com/corpnewt/GenSMBIOS "GenSMBIOS")) | | Target MacOS Version | MacOS Ventura 13.6.1 |  ## What's Working

### 47. [score 6] [GUIDE] How to Activate Microphone on Conexant Codecs and others. - Page 4 - Guides and Tutorials - Hackintosh Olarila
- URL: https://olarila.com/topic/5586-guide-how-to-activate-microphone-on-conexant-codecs-and-others/page/4/
- Date: 2018-12-08T18:05:40.000Z
- Channel: web
- Excerpt: thank you very much, only the jack fix already corrected the microphone .  ...  Alc supports 8150 but my pin config is different. Someone compiled alc for me and I have to use ID 3 but I don't have mic even though it is recognized   Thanks in advance  ...  I've tried jack fix but internal microphone wasn't works only line in audio port works when headphone is connected (ALC255, layout id: 15) help please??  ...  Good Day. I'm having trouble making my earphone mic via combojack work.   I have tried this fix and It does fix the popping and distorted sound on my hack when coming from sleep but still no mic via inline(combojack)   I have ALC255 and I am using AppleALC.   I have also tried creati

### 48. [score 6] really noisy internal mic with appleALC kext - DSDT & Patch Requests - Hackintosh Olarila
- URL: https://olarila.com/topic/13027-really-noisy-internal-mic-with-applealc-kext/
- Date: 2021-03-02T21:06:51.000Z
- Channel: web
- Excerpt: if i use appleALC kext, my jack sense works but my microphone doesn't switch from in built to headset, which works with voodooHDA but i need to manually change it from the settings.    my internal mic produces a lot of static noise which makes it hard for me to record any audio. it's just the static buzz sound.    my laptop doesn't have a codex but the audio layout i use is 28 to make it work(it works with many other layouts too, like 11,14,24, and so on)    i have this static noise with voodooHDA too but it get's low if i turn the masters low in voodooHDA panel, but it takes me to do it manually every time i reboot my system.    this buzzy noise is killing me, please please please help me. 

### 49. [score 6] [GUIDE] How to Activate Microphone on Conexant Codecs and others. - Guides and Tutorials - Hackintosh Olarila
- URL: https://olarila.com/topic/5586-guide-how-to-activate-microphone-on-conexant-codecs-and-others/
- Date: 2018-12-08T18:05:40.000Z
- Channel: web
- Excerpt: is so much time ago I patched AppleHDA for some codecs Conexant but in almost all of them in most of the line CX207xx we had a problem with the microphones, both internal and external, the time was passing, and have developed some solutions of other people, but that didn't work for me at least, until a few days ago I helped @Striker770 mending    ALC294 and your headphones did not work as expected, so it was there that he found a Script in EliteMacx86.com that sends commands to hda-verb, and as a result got all the inputs and outputs activated this included ComboJack, so I'm basing on the idea of goodwin(ALCPlugFix) I did something that solved my problems and it works in most cases for both 

### 50. [score 6] Help with Mic [Apple ALC] : r/hackintosh
- URL: https://www.reddit.com/r/hackintosh/comments/sa7nme/help_with_mic_apple_alc/
- Date: 2022-01-22T17:38:43.000Z
- Channel: web
- Excerpt: CPU: i3-7020u GPU: UHD 620 RAM: 4096 Audio: ALC230 Layout-ID: 20 macOS: 12.1 Model: Lenovo Ideapad 330 15-IKB 81FD  Hello, my hackintosh is almost complete. Everything works perfectly except the microphone. This model has a microphone issue on Linux and macOS. The mic is mono, just one channel, but it is being recognized as stereo, so it's made a phantom channel and only serves to create static noise. I was wondering if someone who understands a bit of AppleALC layouts could help me disable this spare channel.  https://preview.redd.it/vyjjgl7gz9d81.png?width=1015&format=png&auto=webp&s=2a6c8e41d5e34a6877f5be31750d70bcdb0b8e0b  Microfone Integrado: Built-In Mic Dispositivo de entrada padrão: 

### 51. [score 6] ALC 255 - Microphone not getting detected | Page 2 | EliteMacx86 Forum
- URL: https://elitemacx86.com/threads/alc-255-microphone-not-getting-detected.479/page-2
- Date: 2020-02-24T20:56:56.000Z
- Channel: web
- Excerpt: Okay and i guess no input. Check with the supported Layout IDs on AppleALC page. Provide the tests report.  #### SniperBuddy   Yes, no input except the inbult microphone of the laptop.  ...  @EliteMacx86 These are my findings from all the supported layouts for my laptop's codec (ALC 255):    Spoiler: My Findings   Layout 3 - Headphone OK, Speakers OK, Internal Mic OK, No External Mic Layout 13 - Headphone Slightly Distorted, Speakers OK, No Internal Mic, No External Mic Layout 15 - Headphone Distortion, No Internal Speakers, Internal Mic OK, Line in with nothing detected Layout 17 - Good Audio output but low volume, Headphone OK, Speakers OK, Internal Mic OK, No External Mic Layout 18 - No p

### 52. [score 6] longnguyen245/Ryzentosh-Acer-aspire-7-A715-42G-Opencore-EFI
- URL: https://github.com/longnguyen245/Ryzentosh-Acer-aspire-7-A715-42G-Opencore-EFI
- Channel: web
- Excerpt: # Laptop Acer Aspire 7 Gaming alt tag  Supported - Aspire 7 A715-42G-R6ZR - Aspire 7 A715-42G-R05G - Aspire 7 A715-42G-R4ST - Aspire 7 A715-42G-R4XX (Some machines with this code may have problems booting)  ## SYSTEM INFOMATION  | | | | ----------------- | ------------------------------ | | Processor: | AMD Ryzen 5 5500U (APU Mobile) | | Memory: | 8GB x 2 | | Graphics: | AMD Radeon RX Vega 7 (Renoir) | | Wireless Network: | Intel AX210 | | Strorage: | WD SN530 | | Audio: | Realtek ALC255 | | Camera: | HD User Facing |  ## Setup EFI 1. Copy the `EFI` folder to your EFI partition 2. Setup rEFInd (Optional) \  1.1. Edit the `refind.conf` configuration in `EFI/BOOT/refind.conf` according to the 

### 53. [score 6] vladII19/latitude-7390-tahoe-audio
- URL: https://github.com/vladII19/latitude-7390-tahoe-audio
- Channel: web
- Excerpt: # Onboard Audio on macOS 26 Tahoe — Dell Latitude 7390 Hackintosh  Apple removed `AppleHDA.kext` in macOS 26 (Tahoe) beta 2. Because **AppleALC is not a driver** — it patches AppleHDA on the fly — every OpenCore laptop that relied on AppleALC for analog audio lost its speakers, headphone jack and internal microphone the moment it moved to Tahoe.  This repository documents a **working fix** on a Dell Latitude 7390, plus the three approaches that looked promising and failed, so you do not repeat them.  **Result:** Internal Speakers (4 channels, 48 kHz), Internal Microphone (2 channels) and a working volume slider on macOS 26.6.2 (25G83) — verified on real hardware after a clean reboot.  > Ever

### 54. [score 6] 黑苹果ALC声卡驱动：AppleALC.kext 1.9.3-黑苹果星球
- URL: https://heipg.cn/drivers/applealc-1-9-3.html
- Date: 2024-12-21T19:24:29.000Z
- Channel: web
- Excerpt: 黑苹果ALC声卡驱动：AppleALC.kext 1.9.3-黑苹果星球  # 黑苹果ALC声卡驱动：AppleALC.kext 1.9.3   黑酱 2024-12-21 驱动 22.48w 15.94k 40分钟   #### 概述  AppleALC.kext 是一个开放源代码的内核扩展，无需进行任何文件系统修改，即可为不受官方支持的音频编解码器提供 macOS HD 音频。AppleALC 必须配合 Lilu.kext 才可以使用。  - 目前支持 macOS 版本：10.6 及以上 - 驱动版本：AppleALC 1.9.3 - 发布时间：2024 年 12 月 3 日 - 本驱动依赖 Lilu，且无法和 VoodooHDA 共存，必须二选一 - 常见配置使用 AppleALC.kext 即可，如果是数字音频，再添加 AppleALCU.kext - 安装 macOS 时建议使用 Debug 版本以获取更多错误信息，稳定使用推荐 Release 版本  #### 驱动特点  - 操作系统安装界面开始提供对数字和模拟音频的支持 - 恢复模式 Recovery HD / macOS 安装程序 音频支持 - 自动编解码器检测 - 不支持的音频控制器启用（内部和外部） - 任意 kext 修补 - 自定义平台 / 自定义布局注入 - SIP / El Capitan 兼容  #### 启动参数  - alcid = layout -设置值 layout-id； - -alcoff -禁用自身； - -alcdbg -打印调试信息（如果 kext 是在 debug 模式下编译的

### 55. [score 6] 黑苹果ALC声卡驱动：AppleALC.kext 1.9.0-黑苹果星球
- URL: https://heipg.cn/drivers/applealc-1-9-0.html
- Date: 2024-05-13T16:47:55.000Z
- Channel: web
- Excerpt: 黑苹果ALC声卡驱动：AppleALC.kext 1.9.0-黑苹果星球  # 黑苹果ALC声卡驱动：AppleALC.kext 1.9.0   黑酱 2024-05-13 驱动 10.05w 15.04k 38分钟   #### 概述  AppleALC.kext 是一个开放源代码的内核扩展，无需进行任何文件系统修改，即可为不受官方支持的音频编解码器提供 macOS HD 音频。AppleALC 必须配合 Lilu.kext 才可以使用。  - 目前支持 macOS 版本：10.6 及以上 - 驱动版本：AppleALC 1.9.0 - 发布时间：2024 年 5 月 10 日 - 本驱动依赖 Lilu，且无法和 VoodooHDA 共存，必须二选一 - 常见配置使用 AppleALC.kext 即可，如果是数字音频，再添加 AppleALCU.kext - 安装 macOS 时建议使用 Debug 版本以获取更多错误信息，稳定使用推荐 Release 版本  #### 驱动特点  - 操作系统安装界面开始提供对数字和模拟音频的支持 - 恢复模式 Recovery HD / macOS 安装程序 音频支持 - 自动编解码器检测 - 不支持的音频控制器启用（内部和外部） - 任意 kext 修补 - 自定义平台 / 自定义布局注入 - SIP / El Capitan 兼容  #### 启动参数  - alcid = layout -设置值 layout-id； - -alcoff -禁用自身； - -alcdbg -打印调试信息（如果 kext 是在 debug 模式下编译的

### 56. [score 6] AppleALC.kext v1.9.7 黑苹果仿冒声卡驱动 - 黑苹果屋
- URL: https://imacos.top/2026/03/28/applealc-kext-v1-9-7/
- Date: 2026-03-28T00:00:00.000Z
- Channel: web
- Excerpt: AppleALC.kext v1.9.7 黑苹果仿冒声卡驱动 - 黑苹果屋  # AppleALC.kext v1.9.7 黑苹果仿冒声卡驱动   imacos.top 2026-03-28 声卡驱动 1.84k 150 推广   AppleALC声卡驱动，对于黑苹果的安装现在非常方便简单，大多数硬件都被驱动，包括网卡驱动、声卡驱动和显卡驱动，声卡驱动有很多，还有万能的VoodooHD声卡驱动程序，对于声卡驱动很多人都废了九牛二虎之力也没成功，该驱动需要配合lilu.kext来驱动你的声卡。下载地址中已经合集了所有的版本以及AppleALCU.kext！  ...  - - Xezun 为 Lenovo ThinkCentre M920x-N000 添加了 ALC235 布局 ID 20 - 由 cal  ...  - Goldfish64 为 Dell Studio One 19 1909 添加了 ALC262 布局 ID 14 - 耳机修复 ALC255 布局 ID 69，作者：juniorcaesar - 为华硕 ROG Zephyrus G14 GA401IV 添加了 ALC289 布局 ID 33 并修复了 xml 中的布局 ID 93 - 由 Andres ZeroCross 添加了适用于 Axioo MyPC One Pro H5 的 Conexant CX20632 布局 ID 21 - 为联想小新 Air14ALC 添加了 ALC257 布局 ID 101 by htmambo - 为 Lenovo IdeaPad 500-14ISK 添加了 ALC236 

### 57. [score 6] AppleALC.kext v1.9.5 黑苹果仿冒声卡驱动 - 黑苹果屋
- URL: https://imacos.top/2025/07/11/applealc-kext-v1-9-5/
- Date: 2025-07-11T00:00:00.000Z
- Channel: web
- Excerpt: # AppleALC.kext v1.9.5 黑苹果仿冒声卡驱动   imacos.top 2025-07-11 声卡驱动 1.28k 66 推广   AppleALC声卡驱动，对于黑苹果的安装现在非常方便简单，大多数硬件都被驱动，包括网卡驱动、声卡驱动和显卡驱动，声卡驱动有很多，还有万能的VoodooHD声卡驱动程序，对于声卡驱动很多人都废了九牛二虎之力也没成功，该驱动需要配合lilu.kext来驱动你的声卡。下载地址中已经合集了所有的版本以及AppleALCU.kext！  ...  - Goldfish64 为 Dell Studio One 19 1909 添加了 ALC262 布局 ID 14 - 耳机修复 ALC255 布局 ID 69，作者：juniorcaesar - 为华硕 ROG Zephyrus G14 GA401IV 添加了 ALC289 布局 ID 33 并修复了 xml 中的布局 ID 93 - 由 Andres ZeroCross 添加了适用于 Axioo MyPC One Pro H5 的 Conexant CX20632 布局 ID 21 - 为联想小新 Air14ALC 添加了 ALC257 布局 ID 101 by htmambo - 为 Lenovo IdeaPad 500-14ISK 添加了 ALC236 布局 ID 19。启用 Wolf606 的内置扬声器、内置麦克风、插孔麦克风和插孔耳机 - 添加了适用于 XPS 13 9300 的 ALC289 布局 ID 12，带有工作耳机和外部麦克风（由 wern-apfel 提供） - j

### 58. [score 6] AppleALC.kext v1.9.4 黑苹果仿冒声卡驱动 - 黑苹果屋
- URL: https://imacos.top/2025/03/10/applealc-kext-v1-9-4/
- Date: 2025-03-10T00:00:00.000Z
- Channel: web
- Excerpt: # AppleALC.kext v1.9.4 黑苹果仿冒声卡驱动   imacos.top 2025-03-10 声卡驱动 1.81k 103 推广   AppleALC声卡驱动，对于黑苹果的安装现在非常方便简单，大多数硬件都被驱动，包括网卡驱动、声卡驱动和显卡驱动，声卡驱动有很多，还有万能的VoodooHD声卡驱动程序，对于声卡驱动很多人都废了九牛二虎之力也没成功，该驱动需要配合lilu.kext来驱动你的声卡。下载地址中已经合集了所有的版本以及AppleALCU.kext！  ...  - Goldfish64 为 Dell Studio One 19 1909 添加了 ALC262 布局 ID 14 - 耳机修复 ALC255 布局 ID 69，作者：juniorcaesar - 为华硕 ROG Zephyrus G14 GA401IV 添加了 ALC289 布局 ID 33 并修复了 xml 中的布局 ID 93 - 由 Andres ZeroCross 添加了适用于 Axioo MyPC One Pro H5 的 Conexant CX20632 布局 ID 21 - 为联想小新 Air14ALC 添加了 ALC257 布局 ID 101 by htmambo - 为 Lenovo IdeaPad 500-14ISK 添加了 ALC236 布局 ID 19。启用 Wolf606 的内置扬声器、内置麦克风、插孔麦克风和插孔耳机 - 添加了适用于 XPS 13 9300 的 ALC289 布局 ID 12，带有工作耳机和外部麦克风（由 wern-apfel 提供） - 

### 59. [score 6] Dell G3安装macOS后麦克风无法使用，Win/Linux下正常，寻求技术支持
- URL: https://www.volcengine.com/article/2154279
- Date: 2026-08-04T09:50:38.000Z
- Channel: web
- Excerpt: Dell G3没有苹果官方的macOS支持，麦克风失效是黑苹果环境下常见的硬件适配问题，并非完全不支持，以下是具体的排查和修复步骤：  - 检查音频驱动与引导补丁 确认你的黑苹果引导工具（OpenCore/Clover）已加载适配的音频驱动：  - 确保`AppleALC.kext`和`Lilu.kext`为最新版本，旧版本可能与当前macOS版本不兼容。 - Dell G3常见声卡为Realtek ALC256/ALC3246，尝试修改引导配置文件`config.plist`中`Audio -> Inject`的布局ID（Layout ID），常用测试值包括1、3、5、7、11、28，每次修改后重启系统测试麦克风。 - 验证硬件识别状态  - 打开终端，执行命令：`ioreg -l | grep -i microphone`，若无输出，说明系统未检测到麦克风硬件，需检查ACPI补丁（如修复HDEF节点、添加SSDT补丁启用音频控制器）。 - 也可通过`关于本机 -> 系统报告 -> 音频`查看是否有输入设备列出，无设备则优先排查ACPI补丁和驱动加载情况。 - 重置音频服务与配置  - 打开终端，执行`sudo killall coreaudiod`重启音频服务。 - 执行`sudo rm -rf /Library/Preferences/com.apple.coreaudio.plist`删除旧音频配置文件，重启系统后让系统重新生成配置。 - 排查第三方工具干扰 若安装过Boom 3D、Soundflower等音频增强工具，可能会干扰系统默认音频输入，尝试卸载后测试麦克风功

### 60. [score 6] The final thing I need to get working; this godforsaken spawn of Satan: the X1C7s microphone. : r/hackintosh
- URL: https://www.reddit.com/r/hackintosh/comments/svc1g6/the_final_thing_i_need_to_get_working_this/
- Date: 2022-02-18T07:28:20.000Z
- Channel: reddit
- Excerpt: I'm not saying anything, but if I had to choose between making a custom layout for AppleALC and dying right on the spot, it'd be a no brainer. I've tried for the past month to figure this shit out, but its... really, REALLY complicated. Something about graphs... pin configs... whatever. Basically, I need some help with getting the ThinkPad X1C7's internal microphone working. In the past month, a layout was added that drastically improves sound quality on the X1C7, but still no microphone, even using that layout.  ...  **u/pentium0** · 2 points · July 6, 2022 at 7:09 AM UTC > Is there any bounty out on the x1c7 microphone issue? > I'll put $20 on it. > > I just picked up a x1c7 for use as a h

### 61. [score 5] [Guide] HP ProBook 430 G6 (Whiskey Lake) | tonymacx86.com
- URL: https://www.tonymacx86.com/threads/guide-hp-probook-430-g6-whiskey-lake.282302/
- Date: 2019-08-16T20:24:18.000Z
- Channel: web
- Excerpt: Finally I managed to make a pure EFI build (without adding anything to /L/E or /S/L/E). Here is How I did this Hardware CPU: Intel Core i5 3.9GHz RAM: 32Gb 2133 MHz DDR4 GPU: Intel UHD Graphics 620 / PCI [8086: 3ea0] - requires Lilu.kext + WhateverGreen.kext, device-id=a53e0000, AAPL,ig-platform-id=0900a53e; HDMI work, but require patching (see notes below), USB Type-C works with glitches (see notes below) SSD: OCZ-AGILITY3 240 Gb (SATA) Ethernet: Build-in Realtek RTL8168H / PCI [10ec:8168] - requires RealtekRTL8111.kext WiFi: HP 915622-001 (chipset Realtek RTL8822BE) - known to be unsupported, replaced with Dell DW1560 (chipset Broadcom BCM94352Z) which needs AirportBrcmFixup.kext + Lilu.ke

### 62. [score 5] huyhoang8398/x1c7-hackintosh-20R1
- URL: https://github.com/huyhoang8398/x1c7-hackintosh-20R1
- Channel: web
- Excerpt: > ### Non-Fuctional: | Feature | Status | Dependency | Remarks | | :----------------------------------- | ------ | ------------------- | ---------------------------- | | Fingerprint Reader | ❌ | `DISABLED` in BIOS to save power if not used in other OSes. | Linux support was only recently added | | Wireless WAN | ❌ | `DISABLED` in BIOS to save power if not used in other OSes. | Unable to investigate as I have no need and my model did not come with WWAN. | | Internal Microphone | ❌ | `DISABLED` in BIOS to save power | - |  > ### Video and Audio | Feature | Status | Dependency | Remarks | | :----------------------------------- | ------ | ------------------- | ---------------------------- | | Fu

### 63. [score 5] ducks-c/X1C7-macOS
- URL: https://github.com/ducks-c/X1C7-macOS
- Channel: web
- Excerpt: # macOS on ThinkPad X1 Carbon Gen 7 This repository is made to help run macOS on a ThinkPad X1 Carbon Gen 7.  This should help you get started on hackintoshing and any updates can be applied later. I may occasionally update this repo if I find the time but there's no guarantee.  I recommend going through the Opencore install guide once to fully understand everything that is going on here.  **NOTE**: macOS will not work with Samsung PM981/a drives out of the box. Suggest replacing or not using the drive with macOS.  Keep in mind that you have to generate your own serial numbers and ID's and stuff using GenSMBIOS if you're doing a fresh install. Use your old ones from your old config.plist if 

### 64. [score 5] ALC255 | Acer Nitro 5 AN515-54W2 | Audio works perfectly but microphone doesn't. (Ventura) | tonymacx86.com
- URL: https://www.tonymacx86.com/threads/alc255-acer-nitro-5-an515-54w2-audio-works-perfectly-but-microphone-doesnt-ventura.326213/
- Date: 2023-06-27T23:17:24.000Z
- Channel: web
- Excerpt: Hello, I'm currently having issues trying to get the microphone working with the ALC255 codec in MacOS Ventura. Tried a lot of layout-id's shown in the AppleALC github wiki page, but none of them seem to get the mic going. There's any other way around to get it working? I'm using all recomended kexts too, AppleALC+Lilu+AppleHDA.  ...  should not be using DSDT.aml with opencore with ALC255, you can use any of these: layout 3, 11, 12, 13, 15, 17, 18, 20, 21, 22, 23, 27, 28, 29, 30, 31, 37, 66, 69, 71, 82, 86, 96, 99, 100, 255 make sure to try them all, resetting nvram on each try I created 22 as I had mic issues, using a combination of this guide:  ---

### 65. [score 5] Mic not working on MacOS Sonoma hackintosh : r/hackintosh
- URL: https://www.reddit.com/r/hackintosh/comments/1v9si0w/mic_not_working_on_macos_sonoma_hackintosh/
- Date: 2026-07-29T10:41:31.000Z
- Channel: web
- Excerpt: So, everything is working fine. Except the inbuilt microphone. I have the ALC255 audio chipset.  Here are the specs of my system:  i7 4th gen processor  8GB RAM  ALC255 audio chipset  I've literally tried every possible layout IDs but still nothing is working.  Currently the layout-id I've set is 17 which was selected by OCSM, speaker worked, not the microphone. I've also tried using ComboJack but it's also not working.  Please help me, it's so necessary for it to work. I will attach some pictures in the drive so you can figure it out.  ...  **u/Fit_State3622** · 1 point · July 29, 2026 at 11:44 AM UTC > Try getting the supported layouts for ur alc255 from this link https://github.com/acidan

### 66. [score 5] pnapt/ACER-Nitro5-AN515-52-Opencore
- URL: https://github.com/pnapt/ACER-Nitro5-AN515-52-Opencore
- Date: 2023-02-10T11:58:14.000Z
- Channel: web
- Excerpt: # ACER-Nitro5-AN515-52-Opencore Acer Nitro5 AN515-52 Hackintosh (Opencore Bootloader)  # Info Screenshot  **Laptop Specs** | Hardware | Details | |------------|-------------------------------| | Model | Acer Nitro5 2018 (AN515-52) | | BIOS | v1.28 (Insyde BIOS) | | Processor | Intel Core i5 8300H | | Memory | 2x8GB DDR4 2666MHz | | iGPU | Intel UHD Graphics 630 | | dGPU | NVIDIA GeForce GTX 1050Ti | | Wifi | Intel Wireless-AC 9560 | | Trackpad | ELAN | | Sound | Realtek ALC255 | | M.2 Nvme | Colorful SSD CN600 PRO 512 GB |  **OS** | OS | Details | |--------------|-----------------| | macOS | Ventura 13.2 (22D49)| | Dual boot OS | Windows 11 22H2 |  **Highlight** | Status | Name | Notes |  |-

### 67. [score 5] bhazheng/EFI-OpenCore-Acer-Aspire-E5-475G-Hackintosh
- URL: https://github.com/bhazheng/EFI-OpenCore-Acer-Aspire-E5-475G-Hackintosh
- Date: 2021-01-30T04:59:01.000Z
- Channel: web
- Excerpt: Specifications : Processor : Intel Core i5 7200U IGPU : Intel HD Graphics 620 dGPU : Nvidia GT940MX RAM : 4GB DDR4 PC17000 (2133Mhz) Storage : 1x SSD 128GB + 1x Seagate 1TB Wifi : Qualcomm Atheros QCA9377 Wireless Network Adapter and Bluetooth Audio : Realtek ALC255 @ Intel Sunrise Point-LP PCH - High Definition Audio Controller  Ethernet : Realtek RTL8168/8111 PCI-E Gigabit Ethernet Adapter (PHY: Realtek RTL8111) Touchpad : ELAN ELAN1200 I2C Interface Boot Mode : UEFI GPT Screen Size : 14" Display Resolution : 1366 x 768 Bootloader : OpenCore 0.6.4 OS : macOS Big Sur  Work?? QE/CI Graphics Intel HD 620 Sleep and Shutdown CPU Power Management Internal Speaker, Headphone and Internal Micropho

### 68. [score 5] Make your external mic to work through 3.5 mm jack on Acer Swift 5 SF514-52T ALC255 - DEV Community
- URL: https://dev.to/archerallstars/make-your-external-mic-to-work-through-35-mm-jack-on-acer-swift-5-sf514-52t-alc255-3k6h
- Date: 2023-08-15T19:19:27.000Z
- Channel: web
- Excerpt: # Make your external mic to work through 3.5 mm jack on Acer Swift 5 SF514-52T ALC255   > UPDATE: I have created an overlay to fix all audio issues of this laptop model at https://github.com/archerallstars/acer-swift-sf514-52t/tree/main#audio-scripts-audio-fix >  > What works: speakers, 3.5 mm 2-ring headphones, 3.5 mm 3-ring CTIA headset mic, internal AVS DMIC, HDMI audio output. Basically, everything works! >  > You can clone my repo and simply run the `install.sh`. The changes survive reboot, set it and forget it. It works on both immutable and mutable OS. It layers on the host with reversible script available (`uninstall.sh`).   If you're using Acer Swift 5 SF514-52T, your external mic w

### 69. [score 5] Acer SF514-52T-83U3
- URL: https://www.tonymacx86.com/threads/acer-sf514-52t-83u3.261690/
- Date: 2018-10-04T08:07:32.000Z
- Channel: web
- Excerpt: Joined Aug 21, 2016 Messages 4 Motherboard Acer swift 5 SF514-52T-83U3 CPU i7 8550U Graphics UHD620  Hi, I have read your guide and tried to make my own hackintosh, which is maybe similar to the SF315-518S (I think). My computer is Acer SF514-52T-83U3, following is my spec:  - I2C Trackpad + PS2 keyboard - Back-lit keyboard - Audio : ALC255 (ven id:10ec, dev id:0255) - Wifi/Bluetooth : BCM94532Z, (M.2 NGFF) - Ports : 1xUSB 3.1 Gen-1 Type-C, 2xUSB 3.0, 1xHDMI (full-size), 1xAudio jack - Screen: Screen : 14-inch 1920 x 1080 IPS - SSD: 256GB ADATA XPG SX8200 (M.2 2280 NVMe, replaceable. PCIe x4 speeds (3200MBs\1700MBs) ) - RAM: 8GB LPDDR3 - Graphic: Intel UHD 620 - CPU: Intel core i7-8550U (Kab

### 70. [score 5] There's no microphone sound on laptop Acer Swift SF514-53T - Acer Community
- URL: https://community.acer.com/en/discussion/587646/theres-no-microphone-sound-on-laptop-acer-swift-sf514-53t
- Channel: web
- Excerpt: There's no microphone sound on laptop Acer Swift SF514-53T - Acer Community  # There's no microphone sound on laptop Acer Swift SF514-53T  On the notebook, under Settings/Sounds, you can select an input device named "Microphone Array (Intel Smart Sound Technology (Intel SST))".  However, it does not work and does not transmit sounds. The volume bar in this section does not change when you say something.   Also, when I use the Windows Voice recorder for a test, it can't record anything either.  In the "Manage sound devices" section there are two Input devices  1) Microphone Array - Intel Smart Sound Technology (Intel SST)  2) Stereo Mix - Realtek(R) Audio.  And by default "Stereo Mix - Realte

### 71. [score 5] Internal mic and speakers stopped working after Realtek driver update (Swift 5, SF514-53T) - Acer Community
- URL: https://community.acer.com/en/discussion/606257/internal-mic-and-speakers-stopped-working-after-realtek-driver-update-swift-5-sf514-53t
- Channel: web
- Excerpt: Internal mic and speakers stopped working after Realtek driver update (Swift 5, SF514-53T) - Acer Community  # Internal mic and speakers stopped working after Realtek driver update (Swift 5, SF514-53T)   Hi, I updated the Realtek drivers from the Acer site, and both my internal microphone and internal speakers stopped working. Also, headphones plugged into the jack port do not work. However, both microphone and speakers work over USB and Bluetooth! I have googled this problem for 10 hours now, tried every solution offered, updated drivers, BIOS etc. and nothing changes. Some clues: - Realtek doesn't show up in the Device manager. - Under "Sound, video and game controllers", "High Definition 

### 72. [score 5] Tapematch/s340-15iwl-hackintosh
- URL: https://github.com/Tapematch/s340-15iwl-hackintosh
- Date: 2024-01-17T18:51:28.000Z
- Channel: web
- Excerpt: # Lenovo IdeaPad S340-15IWL Hackintosh (WIP)  Configuration for a Hackintosh on a Lenovo IdeaPad S340-15IWL running macOS Sonoma using OpenCore 0.9.7  ### Hardware  - CPU: Intel i7-8565U (Whiskey Lake Q3 2018) - GPU: Intel UHD 620 / MX230 - Chipset: Intel Whiskey Lake-U IMC - Input: I2C - Audio Codec: Intel Cannon Point-LP PCH - cAVS - Network Controller: Dell DW1820a BCM94350ZAE (swapped) - SSD: WD SN730 512GB (swapped)  ### Installation process  1. Change SSD and Network Card 2. Make installer with macOS Big Sur (Ventura Installer did not recognize the SSD)  https://dortania.github.io/OpenCore-Install-Guide/installer-guide/  1. Create EFI with Dortania´s install guide and SSDTTime 2. Updat

### 73. [score 5] [GUIDE]HP Spectre x360 13-ap0037TU(Late 2018) | Page 6 | tonymacx86.com
- URL: https://www.tonymacx86.com/threads/guide-hp-spectre-x360-13-ap0037tu-late-2018.295518/page-6
- Date: 2020-04-12T15:51:02.000Z
- Channel: web
- Excerpt: >  ...  The built-in microphone works by introducing Lilu.kext and AppleALC.kext and setting the Layout ID. I used 11 this time, but other IDs can be used. Brightness works by introducing WhateverGreen.kext, SSDT-PNLF-CFL.aml and adding information about the graphics board in config.plist. The Intel UHD Graphics 620 disguises as the Intel UHD Graphics 630 because it is not adopted by macOS.  ...  my spectre has i7-10510u and UHD 630.... I used your configuration but it doesn't work, I also have to use fake device-id to get a working framebuffer, in each case the in system settings the monitor icon's is wrong, it is shown as external monitor. Maybe it's related to Comet lake, but searching on

### 74. [score 5] Dell E5470 Mojave Internal Microphone not working - The Archive - osxlatitude.com
- URL: https://osxlatitude.com/forums/topic/11803-dell-e5470-mojave-internal-microphone-not-working/
- Date: 2019-06-17T07:35:00.000Z
- Channel: web
- Excerpt: This is my first attempt at hackintosh and it has been pretty exciting for the last one month. I managed to install OS Mojave on Dell E5470 successfully and mostly everything I need every works except the internal microphone. The internal wifi/bluetooth, SD card reader and brightness control does not work. The internal microphone is detected but no input. I am using layout ID 28. In IOreg I can see that it is reconfigured to layout id 7 which as per some forums is correct. I am using AppleALC, lilu and whatevergreen. I have been troubleshooting this for a while but no luck. My build details are I7 6820HQ 16 GB DDR4 RAM, Intel HD530 graphics and ALC 293 Audio. I have attached the ioreg files 

### 75. [score 5] Paul-Eau/Lenovo-ThinkPad-P14s-T14-Gen1-Hackintosh
- URL: https://github.com/Paul-Eau/Lenovo-ThinkPad-P14s-Hackintosh
- Date: 2022-03-31T16:16:43.000Z
- Channel: web
- Excerpt: # Lenovo ThinkPad P14s/T14 Gen1 Hackintosh V3  Two versions in this repository: - DEBUG : for troubleshooting and optimizing EFI, separated SSDT - RELEASE : for daily use, faster startup, all SSDT in one file  Dual boot with Windows / Linux is still possible but in this case, OpenCore only loads macOS, booting Windows / Linux is nevertheless possible directly from UEFI boot entries.  ...  | -------------- | -------------- | | macOS | Sequoia 15.3.1 | | SMBIOS | MacBookPro16,3 | | OpenCore | 1.0.3 |  ...  | Category | Component | Notes | --------- | ---------------------------------------------------- |-----------------------------------------| | CPU | Intel Core i7-10510U | | | iGPU | Intel 

### 76. [score 5] Paul-Eau/Lenovo-ThinkPad-P14s-T14-Gen1-Hackintosh
- URL: https://github.com/Paul-Eau/Lenovo-ThinkPad-P14s-T14-Gen1-Hackintosh
- Date: 2022-03-31T16:16:43.000Z
- Channel: web
- Excerpt: # Lenovo ThinkPad P14s/T14 Gen1 Hackintosh V3  Two versions in this repository: - DEBUG : for troubleshooting and optimizing EFI, separated SSDT - RELEASE : for daily use, faster startup, all SSDT in one file  Dual boot with Windows / Linux is still possible but in this case, OpenCore only loads macOS, booting Windows / Linux is nevertheless possible directly from UEFI boot entries.  ...  | -------------- | -------------- | | macOS | Sequoia 15.3.1 | | SMBIOS | MacBookPro16,3 | | OpenCore | 1.0.3 |  ...  | Category | Component | Notes | --------- | ---------------------------------------------------- |-----------------------------------------| | CPU | Intel Core i7-10510U | | | iGPU | Intel 

### 77. [score 5] Realtek ALC255 Ses Tanıtma Sorunu (Excalibur G770) - osxinfo.net: Hackintosh Türkiye Destek Platformu
- URL: https://osxinfo.net/konu/realtek-alc255-ses-tanitma-sorunu-excalibur-g770.31769/
- Date: 2024-12-07T16:10:25.000Z
- Channel: web
- Excerpt: #### kindo  Bu kart ALC id 3, 13, 17, 27, 28 codek değerlerinden biriyle çalışması gerekir. Hackintool ile Ses sekmesine gel ve hangi kartları görüyor görsel paylaş. Ek olarak: Bu rehbere bak yapamazsan config paylaş. OpenCore ile Hackintosh Sistemlerde Ses Kartı Tanıtmak - osxinfo.net: Hackintosh Türkiye Destek Platformu  ...  > kindo' Alıntı:  >  > Bu kart ALC id 3, 13, 17, 27, 28 codek değerlerinden biriyle çalışması gerekir. Hackintool ile Ses sekmesine gel ve hangi kartları görüyor görsel paylaş. Ek olarak: Bu rehbere bak yapamazsan config paylaş. OpenCore ile Hackintosh Sistemlerde Ses Kartı Tanıtmak - osxinfo.net: Hackintosh Türkiye Destek Platformu  >  > Genişletmek için tıkla ...  H

### 78. [score 5] AppleALC — dynamic AppleHDA patching - Page 144 - AppleALC | InsanelyMac
- URL: https://www.insanelymac.com/forum/topic/311293-applealc-%E2%80%94-dynamic-applehda-patching/page/144/
- Date: 2016-03-07T22:46:47.000Z
- Channel: web
- Excerpt: > Output is working great; input is showing "internal microphone" but it's just white noise and isn't actually picking anything up. My laptop does have two "inputs": There is a 3.5mm jack for a microphone; then it has the built in one.   Please tick "Use Ambient Noise reduction". And check your mic again Sent from my Mi Note 2 using Tapatalk  ...  @vandroiy2012 I have made pull request for ALC285 (Fix Mute icon disable) and this ones. This for ALC298 for Razer Blade 14 2017 use LayoutID = 22 Fix Headphone Fix Internal Speaker Fix Internal Mic Fix External Headphone Pleas check in Github  ...  With Ambient Noise Reduction on it definitely lowers the white noise a ton, but it's still not picki

### 79. [score 5] AppleALC configuration for CX20585 - no internal microphone - New Users Lounge | InsanelyMac
- URL: https://www.insanelymac.com/forum/topic/346638-applealc-configuration-for-cx20585-no-internal-microphone/
- Date: 2021-02-10T20:38:59.000Z
- Channel: web
- Excerpt: I have been struggling with the internal microphone on my hackintosh for a very long time. I added my own layout, platforms and changed pinconfig in AppleALC and... Internal speakers, headphones and line-in works like a charm. But no luck with internal microphone - it's only detected, but no sound is captured. I also tried injecting layout-id in DSDT but no luck either. Any ideas?  ---

### 80. [score 5] hoaug-tran/CirrusAudioFixup
- URL: https://github.com/hoaug-tran/CirrusAudioFixup
- Channel: web
- Excerpt: CirrusAudioFixup enables internal speakers driven by Cirrus Logic smart amplifiers on macOS. It handles amplifier initialization, DSP firmware, speaker tuning, playback and sleep/wake over I2C or native SPI.  **CS35L41 and CS35L56 are currently supported over I2C and SPI.** See amplifier families for other models.  AppleHDA and AppleALC provide the codec route. CirrusAudioFixup manages the amplifiers on that route. Firmware and tuning are embedded in the kext, with no separate firmware installation or userspace service.  ...  ### Audio endpoints and responsibilities  | Endpoint | Responsible driver | Configuration notes | | ------------------------ | -------------------------------------- | 
