Return-Path: <linux-kernel-owner+w=401wt.eu-S1764498AbXHVJRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764498AbXHVJRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763365AbXHVJHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:07:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763355AbXHVJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:07:29 -0400
Date: Wed, 22 Aug 2007 02:06:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc3-mm1
Message-Id: <20070822020648.5ea3a612.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/

- git-ixgbe.patch got dropped - git-net.patch destroyed it

- then git-net got dropped as it doesn't work

- the -mm import-to-git engine still isn't working



Boilerplate:

- See the `hot-fixes' directory for any important updates to this patchset.

- To fetch an -mm tree using git, use (for example)

  git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.16-rc2-mm1
  git-checkout -b local-v2.6.16-rc2-mm1 v2.6.16-rc2-mm1

- -mm kernel commit activity can be reviewed by subscribing to the
  mm-commits mailing list.

        echo "subscribe mm-commits" | mail majordomo@vger.kernel.org

- If you hit a bug in -mm and it is not obvious which patch caused it, it is
  most valuable if you can perform a bisection search to identify which patch
  introduced the bug.  Instructions for this process are at

        http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt

  But beware that this process takes some time (around ten rebuilds and
  reboots), so consider reporting the bug first and if we cannot immediately
  identify the faulty patch, then perform the bisection search.

- When reporting bugs, please try to Cc: the relevant maintainer and mailing
  list on any email.

- When reporting bugs in this kernel via email, please also rewrite the
  email Subject: in some manner to reflect the nature of the bug.  Some
  developers filter by Subject: when looking for messages to read.

- Occasional snapshots of the -mm lineup are uploaded to
  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/ and are announced on
  the mm-commits list.



Changes since 2.6.23-rc2-mm2:

 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-audit-master.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-dma.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-jg-misc.patch
 git-kvm.patch
 git-libata-all.patch
 git-m32r.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-backlight.patch
 git-nfs.patch
 git-nfsd.patch
 git-r8169.patch
 git-selinux.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-sparc64.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-kgdb.patch

 git trees

-blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch.patch
-fix-hpet-init-race.patch
-direct-io-fix-error-path-crashes.patch
-stifb-detect-cards-in-double-buffer-mode-more-reliably.patch
-fbcon-kill-compile-warning.patch
-fbcon-kill-compile-warning-fix.patch
-pvr2fb-fix-oops-when-pseudo_palette-is-written.patch
-pvr2fb-consolidated-cleanup-of-pvr2fbc.patch
-pvr2fb-update-documentation-fb-pvr2fbtxt.patch
-matroxfb-rectify-jitter-g450-g550.patch
-frv-connect-up-fallocate.patch
 ecryptfs-fix-lookup-error-for-special-files.patch
-fix-missing-numa_zonelist_order-sysctl.patch
-remove-unused-struct-proc_dir_entryset.patch
-linux-audit-list-is-subscribers-only.patch
-ecryptfs-fix-error-handling-in-ecryptfs_init.patch
-hibernation-do-not-try-to-mark-invalid-pfns-as-nosave.patch
-drivers-char-pcmcia-cm40x0_csc-fix-release-function-call.patch
-memory-hotplug-document-take-3.patch
-kernel-parameterstxt-watchdogtxt-should-be-wdttxt.patch
-spi_mpc83xx-in-qe-mode-use-sysclk-2.patch
-spi_mpc83xx-fix-prescale-modulus-calculation.patch
-update-checkpatchpl-to-version-009.patch
-documentation-sysrq-description-of-h-slightly-inaccurate.patch
-docs-note-about-select-in-kconfig-languagetxt.patch
-fix-serial-buffer-memory-leak.patch
-fix-serial-buffer-memory-leak-fix.patch
-mtdchar-build-fix.patch
-hex_dump-add-missing-const-qualifiers.patch
-rcu-remove-prototype-for-nonexistent-function.patch
-cris-drivers-cdrom-kconfig-no-longer.patch
-spidev-warning-fix.patch
-timerremove-clockevents_unregister_notifier.patch
-fix-compilation-with-gcc-42.patch
-fix-compilation-with-gcc-42-fix.patch
-lguest-files-should-explicitly-include-asm-paravirth.patch
-alpha-werror-fixes-for-sys_titanc.patch
-readahead-docbook-fix.patch
-finish-i386-and-x86-64-sysdata-conversion.patch
-changing-include-asm-generic-pgtableh-for-non-mmu.patch
-acpi-add-reboot-mechanism-fix.patch
-acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
-make-drivers-acpi-eventcacpi_event_seqnum-static.patch
-acpi-ec-remove-potential-deadlock-from-ec.patch
-emu10k1-remove-redundant-memset.patch
-sound-pci-ioremap-iounmap-balancing.patch
-kcopyd-use-mutex-instead-of-semaphore.patch
-drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
-powerpc-clean-out-a-bunch-of-duplicate-includes.patch
-fix-typos-in-fs-sysfs-filec.patch
-nozomi-shoot-defunct-label.patch
-drivers-base-power-make-2-functions-static.patch
-dma-arch-fix.patch
-dma-intel_ioatdma-build-fix.patch
-git-dma-up-fix.patch
-initialize-filp-private_data-only-once-in-em28xx_v4l2_open.patch
-jdelvare-i2c-i2c-i801-typo-erroneous.patch
-jdelvare-i2c-i2c-mpc-pass-correct-dev_id-to-free_irq.patch
-jdelvare-i2c-i2c-isp1301_omap-build-fixes.patch
-jdelvare-i2c-i2c-iop3xx-set-adapater-class.patch
-jdelvare-i2c-i2c-mpc-dont-disable-i2c-module-on-stop-condition.patch
-ds1682-add-sesnsors-kconfig-variable-prefix.patch
-add-includes-to-scsi_transport_iscsih.patch
-m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
-libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
-ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
-ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
-sata_nv-allow-changing-queue-depth.patch
-libata-adjust-libata-to-ignore-errors-after.patch
-libata-acpi-checks-for-80wire-cable-headers.patch
-libata-acpi-checks-for-80wire-cable-implementation.patch
-libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
-libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
-fix-libata-warnings-with-config_pm=n.patch
-libata-correct-iordy-handling.patch
-libata-check-for-an-support.patch
-libata-send-event-when-an-received.patch
-pata_cmd64x-set-up-mwdma-modes-properly.patch
-ata_piix-disallow-udma-133-on-ich5-ich7.patch
-ide-ide-make-config_ide_generic-default-to-n.patch
-ide-ide-cris-fix-set-pio-mode.patch
-ide-ide-config-drive-for-dma-fixes.patch
-ide-ide-pmac-fix-drive-init-speed-reporting.patch
-ide-ide-add-cable-detection-for-early-udma66-devices-take-3.patch
-ide-ide-config-drive-speed-bugfixes.patch
-ide-cs5530-add-missing-dma-base-check.patch
-ide-pdc202xx_new-add-missing-dma-base-check.patch
-ide-pdc202xx_old-add-missing-dma-base-check.patch
-ide-triflex-add-missing-dma-base-check.patch
-ide-ide-st340823a-hpa-workaround-take-3.patch
-ide-hpt34x-fix-config-hpt34x-autodma-n-handling.patch
-drivers-net-ns83820c-add-paramter-to-disable-auto.patch
-via-rhine-disable-rx_copybreak-on-archs-that.patch
-3c59x-check-return-of-pci_enable_device.patch
-clean-up-duplicate-includes-in-drivers-net.patch
-ax88796-printk-fixes.patch
-usb-remove-redundant-memset-from-amd5536udc.patch
-natsemi-fix-netdev-error-acounting.patch
-drivers-net-remove-superfluous-memset.patch
-net-tulip-xircom_cbc-remove-superfulous-priv-assignment.patch
-3c59x-fix-duplex-configuration.patch
-fore200e_param_bs_queue-must-be-__devinit.patch
-ip_auto_config-fix.patch
-ip_auto_config-fix-fix.patch
-clean-up-duplicate-includes-in-drivers-atm.patch
-clean-up-duplicate-includes-in-net-atm.patch
-clean-up-duplicate-includes-in-net-ipv4.patch
-clean-up-duplicate-includes-in-net-ipv6.patch
-clean-up-duplicate-includes-in-net-sched.patch
-clean-up-duplicate-includes-in-net-sunrpc.patch
-clean-up-duplicate-includes-in-net-tipc.patch
-clean-up-duplicate-includes-in-net-xfrm.patch
-fix-theoretical-ccids_readwrite_lock-race.patch
-fib_trie-cleanup.patch
-fib_trie-cleanup-fix.patch
-fib_trie-macro-cleanup.patch
-dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
-drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc.patch
-drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc.patch
-netconsole-cleanups-codingstyle-prettyfication.patch
-netconsole-remove-bogus-check.patch
-netconsole-simplify-boot-module-option-setup-logic.patch
-netconsole-use-netif_running-in-write_msg.patch
-netconsole-add-some-useful-tips-to-documentation.patch
-netconsole-introduce-netconsole_target.patch
-netconsole-introduce-netconsole_netdev_notifier.patch
-netconsole-support-multiple-logging-targets.patch
-netconsole-support-dynamic-reconfiguration-using-configfs.patch
-introduce-u16_max-and-u32_max.patch
-introduce-u16_max-and-u32_max-fix.patch
-introduce-strtol_check_range.patch
-introduce-strtol_check_range-fix.patch
-backlight-make-2-structs-static.patch
-fix-several-memory-leaks-in-cr_backlight_probe-take2.patch
-64-bit-ino-support-for-nfs-client.patch
-dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
-serial-add-support-for-ite-887x-chips.patch
-serial_txx9-fix-modem-control-line-handling.patch
-serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
-serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
-add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
-add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
-kernel-schedc-make-code-static.patch
-sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
-aacraid-rename-check_reset.patch
-incorrect-scsi-transfer-length-computation-from-odd.patch
-clean-up-duplicate-includes-in-drivers-scsi.patch
-megaraid-add-cerc_ata100-support.patch
-drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
-dtc-clean-up-indent-damage-and-add-printk-levels.patch
-drivers-scsi-scsi_errorc-should-include.patch
-drivers-scsi-constantsc-make-2-functions-static.patch
-drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
-drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
-drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-scsi-ipsc-fix-scsi_add_host-warning.patch
-drivers-scsi-ipsc-fix-scsi_add_host-warning-fix.patch
-scsi-ipsc-warning-fix.patch
-clean-up-duplicate-includes-in-drivers-block.patch
-drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc.patch
-sysace-hdio_getgeo-has-its-own-method-for-ages.patch
-gregkh-usb-usb-px2xx_udc-bugfix-missing-check-for-gpio_pullup.patch
-gregkh-usb-usb-fix-bug-with-ehci-cpufreq-patch-on-nvidia-controllers.patch
-usb-typo-in-usb-r8a66597-hcd-config.patch
-nikon-d50-is-an-unusual-device.patch
-kl5kusb105-switch-to-new-speed-api.patch
-mct_u232-convert-to-proper-speed-handling-api-fix.patch
-drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
-usb-enable-hcd-support-on-sh-unconditionally.patch
-usb-r8a66597-hcd-clean-up-error-path.patch
-x86_64-mm-pci-mmconfig-eax.patch
-revert-x86_64-mm-pci-mmconfig-eax.patch
-fix-x86_64-mm-early-quirks-unification.patch
-x86_64-clean-up-apicid_to_node-declaration.patch
-x86_64-block-irq-balancing-for-timer.patch
-i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
-i386-vdso-install-unstripped-copies-on-disk.patch
-i386-vdso-install-unstripped-copies-on-disk-fix.patch
-x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
-x86_64-hide-cond_syscall-behind-__kernel__.patch
-x86_64-vdso-install-unstripped-copies-on-disk.patch
-arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
-x86_64-make-acpi-the-default-reset-option.patch
-mmconfig-validate-against-acpi-motherboard-resources.patch
-x86_64-use-wbinvd-macro-instead-of-raw-inline-assembly-in-c-files.patch
-i386-remove-unnecessary-code.patch
-x86_64-use-descriptors-functions-instead-of-inline-assembly.patch
-clean-up-duplicate-includes-in-arch-i386-xen.patch
-mtrr-simplify-smp_call_function_single-call-sequence.patch
-cpuid-driver-simplify-smp_call_function_single-call-sequence.patch
-msr-driver-simplify-smp_call_function_single-call-sequence.patch
-x86-disable-unhandled-signals-printk-by-default.patch
-x86_64-store-core-id-bits-in-cpuinfo_x8.patch
-x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
-x86_64-remove-never-used-apic_mapped.patch
-x86-add-cpu-codenames-for-kconfigcpu.patch
-change-order-in-kconfigcpu-i386.patch
-i386-add-amd64-barcelona-pmu-msr-definitions.patch
-i386-remove-maccumulate-outgoing-args.patch
-arch-i386-mach-generic-probec-make-struct-apic_probe.patch
-arch-i386-mach-es7000-es7000platc-cleanups.patch
-i386-alternativec-really-stop-mces-during-code.patch
-i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
-arch-i386-mm-discontigc-make-some-variables-static.patch
-x86-expand-proc-interrupts-to-include-missing-vectors-v2.patch
-expand-proc-interrupts-to-include-missing-vectors-v3.patch
-x86-expand-proc-interrupts-to-include-missing-vectors.patch
-arch-x86_64-kernel-io_apicc-kmalloc-memset-conversion-to-kzalloc.patch
-optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
-x86_64-remove-sync_arb_ids.patch
-x86_64-clear-io_apic-before-enabing-apic-error-vector.patch
-x86_64-get-mp_bus_to_node-as-early-v3-fix.patch
-consolidate-show_regs-and-show_registers-for-i386.patch
-i386-clean-up-oops-bug-reports.patch
-x86_64-remove-x86_cpu_to_log_apicid.patch
-fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
-dma_free_coherent-needs-irqs-enabled-sigh.patch
-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
-sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
-sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
-tpmdd-maintainers.patch
-make-oprofile-call-shutdown-only-once-per-session.patch
-perfctr_watchdog-do-not-bug_on-when-msr-is-unknown.patch
-acpi-bay-send-envp-with-uevent-fix.patch
-acpi-dock-send-key=value-pair-instead-of-plain-value.patch
-kernel-auditscc-fix-an-off-by-one.patch
-document-linux-memory-policy-v3.patch
-futex_unlock_pi-hurts-my-brain-and-may-cause.patch
-block-hide-the-contents-of-linux-bioh-if-config_block=n.patch
-rtc-periodic-irq-fix.patch
-calgary-fix-mis-handled-pci-topology.patch
-fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch
-belkin_sa-avoid-divide-by-zero-error.patch
-pci-align-bar-settings-for-legacy-mode-ide-fix.patch
-ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
-wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
-wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch
-sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks.patch

 Merged into mainline or a subsystem tree

+sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
+tpmdd-maintainers.patch
+kernel-auditscc-fix-an-off-by-one.patch
+document-linux-memory-policy-v3.patch
+futex_unlock_pi-hurts-my-brain-and-may-cause.patch
+dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
+serial-add-support-for-ite-887x-chips.patch
+serial_txx9-fix-modem-control-line-handling.patch
+serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
+add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
+free_irq-fix-debug_shirq-handling.patch
+documentation-fix-getdelaysc-example-l-option-and-segv.patch
+h8300-missing-include.patch
+ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
+wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
+wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch
+correct-name-for-rtc-m41t80.patch
+fix-null-pointer-dereference-in-__vm_enough_memory.patch
+m68k-asm-pageh-needs-linux-compilerh.patch
+m68k-kill-superfluous-extern.patch
+m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
+remove-dead-code-in-via-pmu68k.patch
+m68k-use-_ac-instead-of-ifdef-__assembly__.patch
+m68k-enable-arbitary-speed-tty-support.patch
+m68k-dont-include-rodata-into-text-segment.patch
+m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch
+zorro-make-sysfs-config-attribute-read-only.patch
+m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch
+introduce-config_check_signature-was-re-uninline.patch
+posix-timers-fix-deletion-race.patch
+posix-timers-fix-creation-race.patch
+signalfd-fix-interaction-with-posix-timers.patch
+signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
+ipmi-fix-warning-in-ipmi_si_intfc.patch
+slab-skip-calling-cache_free_alien-when-the-platform-is-not-numa-capable.patch
+synclink_gt-fix-module-reference.patch
+fix-vm_fault-flags-conversion-for-hugetlb.patch
+w1-fix-w1_remove_master_device-searching.patch
+md-make-sure-a-re-add-after-a-restart-honours-bitmap-when-resyncing.patch
+md-correctly-update-sysfs-when-a-raid1-is-reshaped.patch
+uml-fix-previous-request-size-limit-fix.patch
+autofs4-deadlock-during-create.patch
+serial-add-pci-ids-for-pa-semi-pwrficient-onchip-uarts.patch
+cfag12864b-fix.patch
+slub-use-atomic_long_read-for-atomic_long-variables.patch
+slub-do-not-fail-on-broken-memory-configurations.patch
+rtc-max6902-minor-fixes.patch
+exec-kill-unsafe-bug_onsig-count-checks.patch
+xen-i386-xen-heads-fix-sections-mixup-update-2.patch
+check-for-ppc32-in-imsttfb.patch
+selectionh-add-tty_struct-forward-declaration.patch
+newport_con-warning-fix.patch
+i386-fix-lazy-mode-vmalloc-synchronization-for-paravirt.patch
+get_nodes-should-ignore-invalid-node.patch
+fix-ensure-we-dont-use-bootconsoles-after-init-has-been-released.patch
+au1100fb-move-au1100fb_fb_blank-beforce.patch

 2.6.23 queue

+enable-gpes-before-calling-_wak-on-resume.patch
+acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type.patch
+hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch

 ACPI things

+agk-dm-dm-crypt-drop-device-ref-in-ctr-error-path.patch
+agk-dm-dm-crypt-missing-kfree-in-ctr-error-path.patch
+agk-dm-dm-raid1-fix-leakage.patch
+agk-dm-dm-delay-fix-ctr-error-paths.patch
+agk-dm-dm-rdac-fix-request-cmd_flags.patch
+agk-dm-dm-use-kzalloc.patch
+agk-dm-kcopyd-use-mutex-instead-of-semaphore.patch
+agk-dm-dm-delay-fix-status.patch
+agk-dm-dm-use-is_power_of_2.patch

 DM tree updates

+powerpc-vdso-install-unstripped-copies-on-disk-update.patch

 Fix powerpc-vdso-install-unstripped-copies-on-disk.patch

+gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
+gregkh-driver-dmi-id-use-dynamic-sysfs-attributes.patch
+gregkh-driver-dmi-id-possible-cleanup.patch
+gregkh-driver-convert-from-class_device-to-device-for-drivers-video.patch
+gregkh-driver-convert-from-class_device-to-device-in-drivers-char.patch
+gregkh-driver-no-uevent-without-hotplug.patch
+gregkh-driver-uevent-bus-driver.patch
+gregkh-driver-kobject_uevent_trivial.patch
+gregkh-driver-fix-firmware-class-name-collision.patch
+gregkh-driver-drivers-base-power-make-2-functions-static.patch
+gregkh-driver-sysfs-fix-typos-in-fs-sysfs-filec.patch

 driver tree updates

+fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
+fix-2-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
+fix-3-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
+fix-4-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch

 Fix it

+git-dma-makefile-fix.patch
+disable-ioat.patch

 Make git-dma work better

+fix-mux-setup-for-composite-sound-on-avertv-307.patch

 dvb fix

+jdelvare-i2c-i2c-piix4-fix-ati-pci-ids.patch
+jdelvare-i2c-i2c-tps65010-new-style-part-1.patch
+jdelvare-i2c-i2c-tps65010-new-style-part-2.patch

 I2C tree updates

+infiniband-work-around-gcc-slub-problem.patch

 infiniband-vs-slub weirdness

-adbhid-produce-all-capslock-key-events-fix.patch

 Folded into adbhid-produce-all-capslock-key-events.patch

+keyboard-capsshift-lock.patch
+10-dots-braille-keyboards.patch
+console-keyboard-events-and-accessibility.patch
+console-keyboard-events-and-accessibility-fix.patch
+console-keyboard-events-and-accessibility-fix-2.patch

 input things

+pass-g-to-assembler-under-config_debug_info-fix.patch

 Fix pass-g-to-assembler-under-config_debug_info.patch

-alpm-store-interrupt-value.patch
-alpm-increase-number-of-allowable-device-flags.patch
-alpm-enable-link-power-management-for-ata-drivers.patch
-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch

 These got collaterally damaged

+ide-it8213-piix-slc90e66-de-couple-pio-and-udma-modes.patch
+ide-sis5513-clear-prefetch-and-postwrite-for-atapi-devices.patch
+ide-sis5513-remove-proc-ide-sis.patch
+ide-ide-use-pci-vdevice.patch
+ide-ide-remove-config-blk-dev-idedma-forced.patch
+ide-ide-remove-idex-autodma-kernel-parameter.patch
+ide-ide-remove-hwif-autodma-and-drive-autodma.patch
+ide-ide-add-hdx-nodma-kernel-parameter.patch
+ide-ide-remove-config-idedma-onlydisk.patch
+ide-ide-pci-generic-add-declare-generic-pci-dev-macro.patch

 IDE tree updates

+fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
+fix-ide-ide-remove-ide-dma-check.patch

 Fix it

+mips-add-gpio-support-to-the-bcm947xx-platform.patch
+mips-gpio-led-driver-for-the-wgt634u-machine.patch
+mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
+mips-add-cfe-support-to-bcm947xx-code.patch
+mips-irix_getcontext-will-always-fail-efault.patch

 MIPS things

+git-mmc-fixup.patch

 Fix git-mmc.patch

+gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch

 Fix git-mmc it for changes in the driver tree

+drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch

 MTD fix

+add-3c59x-maintainer.patch
+eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
+avoid-possible-null-pointer-deref-in-3c359-driver.patch
+3c59x-check-return-of-pci_enable_device.patch
+dont-use-gfp_dma-for-zone-allocation.patch
+dm9000-fix-interface-hang-under-load.patch

 netdev updates

+git-nfs-vs-git-unionfs.patch

 the nfs tree broke the unionfs tree

+move-a-few-definitions-to-au1000_xxs1500c.patch

 pcmcia cleanup

+serial-keep-the-dtr-setting-for-serial-console.patch

 serial fix

+gregkh-pci-pci-make-pcie_get_readrq-visible-in-pcih.patch
+gregkh-pci-pciehp-remove-config_hotplug_pci_pcie_poll_event_mode.patch
+gregkh-pci-pci-hotplug-pciehp-dont-check-bridge-control-on-remove.patch
+gregkh-pci-pci-hotplug-pciehp-request-control-over-pci-express-capability-as-well-as-native-hotplug.patch
+gregkh-pci-pciehp-remove-dbg_xxx_routine.patch
+gregkh-pci-pciehp-remove-trailing-whitespace-from-pciehp_hpcc.patch
+gregkh-pci-pciehp-remove-trailing-whitespace-from-pciehp_corec.patch
+gregkh-pci-pciehp-remove-trailing-whitespace-from-pciehp_ctrlc.patch
+gregkh-pci-pciehp-remove-trailing-whitespace-form-pciehp_pcic.patch
+gregkh-pci-pciehp-minor-cleanups-for-pciehp_hpcc.patch
+gregkh-pci-pci-is_power_of_2-in-drivers-pci-pcic.patch
+gregkh-pci-pci-hotplug-ibmphp-convert-to-kthread.patch
+gregkh-pci-pci-hotplug-cpqphp-convert-to-kthread.patch
+gregkh-pci-dma_free_coherent-needs-irqs-enabled.patch

 PCi tree updates

+sched-fix-broken-smt-mc-optimizations-with-cfs.patch
+sched-skip-updating-rqs-next_balance-under-null-sd.patch
+rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch

 sched updates

+add-includes-to-scsi_transport_iscsih.patch
+scsi-send-media-state-change-modification-events.patch
+hptiop-use-pci-vendor-symbol.patch
+fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver.patch
+advansys-printk-fix.patch

 scsi fixes

+gregkh-usb-usb-fix-support-for-dell-wireless-broadband.patch
+gregkh-usb-usb-enable-hcd-support-on-sh-unconditionally.patch
+gregkh-usb-usb-r8a66597-hcd-fix-up-error-path.patch
+gregkh-usb-usb-quirks-multicard-reader-doesn-t-like-autosuspend.patch
+gregkh-usb-usb-support-for-the-evolution-scorpion-robots.patch
+gregkh-usb-usb-belkin_sa-avoid-divide-by-zero-error.patch
+gregkh-usb-usb-remove-debug-definition-from-dummy_hcd.patch
+gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
+gregkh-usb-usb-blacklist-samsung-ml-2010-printer.patch
+gregkh-usb-usb-accept-1-byte-device-status-replies-fixing-some-b0rken-devices.patch
+gregkh-usb-usb-typo-in-usb-r8a66597-hcd-config.patch
+gregkh-usb-usb-make-hcds-responsible-for-managing-endpoint-queues.patch
+gregkh-usb-usb-don-t-touch-sysfs-stuff-when-altsetting-is-unchanged.patch
+gregkh-usb-usb-cleanups-for-g_file_storage.patch
+gregkh-usb-usb-sisusb2vga-whitespace-cleanups.patch
+gregkh-usb-usb-sisusb2vga-remove-if-0-ed-code.patch
+gregkh-usb-usb-sisusb2vga-mis-spelled-word.patch
+gregkh-usb-usb-sisusb2vga-lindent-drivers-usb-misc-sisusbvga-sisusbh.patch
+gregkh-usb-usb-sisusb2vga-lindent-drivers-usb-misc-sisusbvga-sisusb_initc.patch
+gregkh-usb-usb-sisusb2vga-lindent-drivers-usb-misc-sisusbvga-sisusb_inith.patch
+gregkh-usb-usb-sisusb2vga-lindent-drivers-usb-misc-sisusbvga-sisusb_structh.patch
+gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
+gregkh-usb-usblp-mutex-in-usblp_check_status.patch
+gregkh-usb-usblp-cosmetics.patch
+gregkh-usb-usbmon-update-pipe-removal-to-suit-my-taste.patch
+gregkh-usb-usbmon-drop-dma-mapping-for-setup-packet.patch
+gregkh-usb-usbmon-smooth-the-core-code.patch
+gregkh-usb-usblp-fix-a-double-kfree.patch
+gregkh-usb-usb-kl5kusb105-witch-to-new-speed-api.patch
+gregkh-usb-usb-mct_u232-convert-to-proper-speed-handling-api-fix.patch
+gregkh-usb-usb-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
+gregkh-usb-usb-remove-redundant-memset-from-amd5536udc.patch

 USB tree updates

+fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
+ohci-fix-oddball-gcc-warning.patch

 USB fixes

-disable-b44-and-bcm43xx.patch

 Unneeded

+git-wireless-fixup.patch
+git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
+git-wireless-printk-fixes.patch
+net-add-ath5k-wireless-driver.patch
+net-add-ath5k-wireless-driver-fix.patch
+ath5k-printk-fix.patch
+ath5k-kconfig-fix.patch
+ath5k-needs-pci.patch

 wireless stuff

+x86_64-mm-unwinder.patch
+x86_64-mm-tsc-unstable.patch
+x86_64-mm-sched-clock-share.patch
+x86_64-mm-sched-clock64.patch
+x86_64-mm-vdso-text-offset.patch
+x86_64-mm-create-clflush-inline-remove-hardcoded-wbinvd.patch
+x86_64-mm-i386-add-amd64-barcelona-pmu-msr-definitions.patch
+x86_64-mm-do-not-bug_on-when-msr-is-unknown.patch
+x86_64-mm-make-oprofile-call-shutdown-only-once-per-session.patch
+x86_64-mm-0-null-for-arch-x86_64.patch
+x86_64-mm-less-stack-alignment.patch
+x86_64-mm-pci-gart-cleanups.patch
+x86_64-mm-iommu-merge.patch
+x86_64-mm-make-callgraph-use-dump_trace-on-i386-x86_64.patch
+x86_64-mm-introduce-frame_pointer-and-stack_pointer.patch
+x86_64-mm-remove-sync_arb_ids.patch
+x86_64-mm-clear-io_apic-before-enabing-apic-error-vector.patch
+x86_64-mm-convert-mm_context_t-semaphore-to-a-mutex.patch
+x86_64-mm-clean-up-apicid_to_node-declaration.patch
+x86_64-mm-consolidate-show_regs-and-show_registers-for-i386.patch
+x86_64-mm-mtrr-smp-call-function.patch
+x86_64-mm-make-struct-apic_probe-static.patch
+x86_64-mm-hide-cond_syscall-behind-__kernel.patch
+x86_64-mm-es7000-cleanups.patch
+x86_64-mm-no-need-to-make-enable_cpu_hotplug-a-variable.patch
+x86_64-mm-make-some-variables-static.patch
+x86_64-mm-kmalloc-memset-conversion-to-kzalloc.patch
+x86_64-mm-remove-maccumulate-outgoing-args.patch
+x86_64-mm-setup_trampoline-must-be-__cpuinit.patch
+x86_64-mm-block-irq-balancing-for-timer.patch
+x86_64-mm-deactivate-the-test-for-the-dead-config_debug_page_type.patch
+x86_64-mm-install-unstripped-copies-on-disk.patch
+x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
+x86_64-mm-x86_64-vdso-install-unstripped-copies-on-disk.patch
+x86_64-mm-validate-against-acpi-motherboard-resources.patch
+x86_64-mm-remove-unnecessary-code.patch
+x86_64-mm-use-descriptors-functions-instead-of-inline-assembly.patch
+x86_64-mm-clean-up-duplicate-includes-in-arch-i386-xen.patch
+x86_64-mm-implify-smp_call_function_single-call-sequence.patch
+x86_64-mm-simplify-smp_call_function_single-call-sequence.patch
+x86_64-mm-store-core-id-bits-in-cpuinfo_x8.patch
+x86_64-mm-use-core-id-bits-for-apicid_to_node-initialization.patch
+x86_64-mm-remove-never-used-apic_mapped.patch
+x86_64-mm-add-cpu-codenames-for-kconfig_cpu.patch
+x86_64-mm-change-order-in-kconfig_cpu.patch
+x86_64-mm-clean-up-oops-bug-reports.patch
+x86_64-mm-expand-proc-interrupts-to-include-missing-vectors.patch
+x86_64-mm-remove-x86_cpu_to_log_apicid.patch
+x86_64-mm-bp-apic-init.patch
+x86_64-mm-cpa-clflush.patch
+x86_64-mm-cpa-cleanup.patch
+x86_64-mm-cpa-einval.patch
+x86_64-mm-cpa-arch-macro.patch
+x86_64-mm-remove-str-macros.patch
+x86_64-mm-save-registers-in-saved_context-during-suspend-and-hibernation.patch
+x86_64-mm-svm-disabled.patch

 x86 tree updates

-nohz-fix-nohz-x86-dyntick-idle-handling.patch

 Dropped - it killed the Vaio

+optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
+x86_64-get-mp_bus_to_node-as-early-v3-update.patch
+x86-make-io-apic-not-connected-pin-print-complete.patch
+i386-optimize-memset-of-6-and-8-bytes.patch

 x86 updates

+serio-fix-modpost-warning.patch
+nfs-fix-oops-re-sysctls-and-v4-support.patch
+accounting-regression-since-rc1.patch
+sysfs-dont-warn-on-removal-of-a-nonexistent-binary-file.patch
+usb-storage-fix-bugs-in-the-disconnect-pathway.patch
+g_file_storage-fix-bug-in-dma-buffer-handling.patch
+pcmcia-cistpl-use-get_unaligned-in-cis-parsing.patch
+atl1-disable-broken-64-bit-dma.patch
+therm_throtc-fix-section-mismatch.patch

 2.6.23 things which go via subsystem maintainers

+generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch

 Fix generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch

+x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch

 Fix x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch

+ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch

 Fix ia64-sparsemem_vmemmap-16k-page-size-support.patch

+sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch

 Fix sparc64-sparsemem_vmemmap-support.patch

+ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch

 Fix ppc64-sparsemem_vmemmap-support.patch some more

+move-mm_struct-and-vm_area_struct-fix.patch

 Fix move-mm_struct-and-vm_area_struct.patch

+slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
+calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch
+slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
+mm-add-end_buffer_read-helper-function.patch
+fs-fix-nobh-error-handling.patch
+fix-the-max-path-calculation-in-radix-treec.patch

 MM things

+git-nfs-vs-nfs-convert-to-new-aops.patch

 Fix nfs-convert-to-new-aops.patch

+memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch

 Fix memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch

+memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch

 Fix memoryless nodes patches in -mm

+flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
+flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch

 Fix flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch

+memory-hotplug-hot-add-with-sparsemem-vmemmap.patch

 Fix memory hotunplug patches in -mm for the virtual memmap patches in -mm.

+mm-mempolicyc-cleanups-fix.patch

 Fix mm-mempolicyc-cleanups.patch

+security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch

 Fix security-convert-lsm-into-a-static-interface.patch even more

+file-capabilities-clear-fcaps-on-inode-change-fix.patch

 Fix file-capabilities-clear-fcaps-on-inode-change.patch

+security-cleanups.patch

 the security code was dirty

+make-kernel-power-maincsuspend_enter-static.patch

 cleanup

+serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
+serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
+s2ram-kill-old-debugging-junk.patch

 power management updates

+uml-throw-out-config_mode_tt.patch
+uml-remove-sysdep-threadh.patch
+uml-style-fixes-pass-1.patch
+uml-throw-out-choose_mode.patch
+uml-style-fixes-pass-2.patch
+uml-remove-code-made-redundant-by-choose_mode-removal.patch
+uml-style-fixes-pass-3.patch
+uml-remove-__u64-usage-from-physical-memory-subsystem.patch
+uml-get-rid-of-do_longjmp.patch
+uml-fold-mmu_context_skas-into-mm_context.patch
+uml-rename-pt_regs-general-purpose-register-file.patch
+uml-free-ldt-state-on-process-exit.patch
+uml-remove-os_-usage-from-userspace-files.patch
+uml-replace-clone-with-fork.patch
+uml-fix-inlines.patch
+uml-use-64-bits-for-block-size-on-x86_64.patch
+uml-userspace-files-should-call-libc-directly.patch
+uml-clean-up-tlb-flush-path.patch
+uml-remove-unneeded-if-from-hostfs.patch
+uml-fix-hostfs-style.patch

 UML updates

-fs-partitions-checkc-add-add_partition-error-handling.patch

 This died - dropped

+ufs-fix-sun-state.patch

 UFS fix

+wait_task_zombie-dont-fight-with-non-existing-race-with-a-dying-ptracee.patch
+__group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task.patch

 thread management fixes/cleanups

+unicode-diacritics-support-s390-fix.patch

 Fix unicode-diacritics-support.patch

+pie-executable-randomization.patch
+pie-executable-randomization-fix.patch
+pie-executable-randomization-fix-2.patch
+cramfs-error-message-about-endianess.patch
+remove-strict-ansi-check-from-__u64-in-asm-typesh.patch
+shrink-struct-task_structoomkilladj.patch
+remove-struct-task_structio_wait.patch
+ext2-4-use-is_power_of_2.patch
+limit-minixfs-printks-on-corrupted-dir-i_size.patch
+kconfig-syntax-cleanups.patch
+kernel-time-timekeepingc-cleanups.patch
+make-fs-libfscsimple_commit_write-static.patch
+allow-disabling-dnotify-without-embedded.patch
+seqfile-merge-duplite-code-to-seq_open_private.patch
+use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
+use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
+make-rcutorture-rng-use-temporal-entropy.patch
+aio-account-i-o-wait-time-properly.patch
+fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
+exec-simplify-sighand-switching.patch
+exec-simplify-the-new-sighand-allocation.patch
+exec-consolidate-2-fast-paths.patch
+exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch
+do_sigaction-dont-worry-about-signal_pending.patch
+jbd-remove-printk-from-j_assert-macros.patch
+jbd2-remove-printk-from-j_assert-macros.patch
+autofs4-reinstate-negatitive-timeout-of-mount-fails.patch
+add-stack-checking-for-blackfin.patch
+binfmt_flat-warning-fixes.patch

 The infamous misc

+omap2-mcspi-code-cleanup.patch

 omap cleanup

+remove-fs-ext2-balloccreserve_blocks.patch

 Clean up the ext2 patches in -mm

+rtc-periodic-irq-fix.patch

 RTC fix

+uvesafb-the-driver-core-uvesafb-set-the-refresh-rate-to-60hz-if-nocrtc-is-used.patch
+uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch
+uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch
+uvesafb-the-driver-core-uvesafb-use-visual_truecolor-as-the-default-visual.patch
+uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch
+uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
+uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
+pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
+pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
+fbdev-fb_create_modedb-non-static-int-first-=-1.patch
+fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
+pm2fb-permedia-2v-hardware-cursor-support.patch
+pm3fb-hardware-cursor-support.patch
+s3c2410fb-code-cleanup.patch
+s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
+s3c2410fb-multi-display-support.patch
+s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
+s3c2410fb-use-new-margin-fields.patch
+s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
+s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
+s3c2410fb-use-vertical-margins-values.patch
+s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
+s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
+s3c2410fb-fix-missing-registers-offset.patch

 fbdev updates

+ext4-remove-obsolete-fragments.patch

 ext4 leanup

+pnp-fix-up-after-lindent.patch
+pnpacpi-simplify-irq_flags.patch
+pnpacpi-remove-unnecessary-casts-of-void.patch
+isapnp-removed-unused-isapnp_detected-and-isapnp_debug.patch
+pnp-remove-module-infrastructure.patch
+pnp-remove-null-pointer-checks.patch
+pnp-make-pnpacpi_suspend-handle-errors.patch

 pnp updates

+memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch

 fix swap-prefetch for memoryless nodes

+sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch

 Fix sysctl-error-on-bad-sysctl-tables.patch

+sysctl-remove-broken-cdrom-binary-sysctls-update.patch

 Fix sysctl-remove-broken-cdrom-binary-sysctls.patch

+sysctl-parport-remove-binary-paths.patch
+sysctl-simplify-the-pty-sysctl-logic.patch
+sysctl-remove-broken-netfilter-binary-sysctls.patch
+sysctl-clean-up-the-sched-debug-sysctl-usage.patch
+sysctl-update-sysctl_checks-list-of-binary-paths.patch
+sysctl-remove-the-cad_pid-binary-sysctl-path.patch

 More sysctl work

+v3-file-capabilities-alter-behavior-of-cap_setpcap.patch

 An out-of-place file capabilities update

+char-mxser_new-upgrade-to-110.patch
+char-mxser_new-move-to-pci_vdevice.patch
+char-mxser_new-remove-useless-comments-in-mxser_cards.patch

 serial driver work

-update-getdelays-to-become-containerstats-aware.patch

 Dropped, I think.

+pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
+pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
+pid-namespaces-rework-forget_original_parent.patch
+pid-namespaces-move-exit_task_namespaces.patch
+pid-namespaces-introduce-ms_kernmount-flag.patch
+pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
+pid-namespaces-introduce-struct-upid.patch
+pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
+pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
+pid-namespaces-helpers-to-obtain-pid-numbers.patch
+pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
+pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
+pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
+pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
+pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
+pid-namespaces-allow-cloning-of-new-namespace.patch
+pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
+pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
+pid-namespaces-initialize-the-namespaces-proc_mnt.patch
+pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
+pid-namespaces-allow-signalling-container-init.patch
+pid-namespaces-destroy-pid-namespace-on-inits-death.patch
+pid-namespaces-changes-to-show-virtual-ids-to-user.patch
+pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
+pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
+pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
+pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
+pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
+pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
+pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
+isolate-some-explicit-usage-of-task-tgid.patch

 pid namespaces updates

+add-missing-newlines-to-some-uses-of-dev_level-messages.patch

 cleanup

+add-scaled-time-to-taskstats-based-process-accounting.patch
+add-missing-newlines-to-some-uses-of-dev_level-messages-fix.patch
+powerpc-add-scaled-time-accounting.patch

 process accounting feature work

+fs-select-remove-unused-macros.patch
+cyber2000fb-rename-bit-macro.patch
+i2c-pxa-rename-bit-macro-to-pxa_bit.patch
+s2io-rename-bit-macro.patch
+amba-pl011-rename-bit-macro.patch
+define-first-set-of-bit-macros.patch
+get-rid-of-input-bit-duplicate-defines.patch
+define-global-bit-macro.patch
+flashpoint-use-bit-instead-of-bitw.patch

 cleanups

+proc-export-a-processes-resource-limits-via-proc-pid.patch
+fix-tsk-exit_state-usage-resend.patch
+isolate-the-explicit-usage-of-signal-pgrp.patch

 More task management updates

+reiser4-fix-readpage_unix_file.patch
+reiser4-cryptcompress-misc-fixups-2.patch
+reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch

 reiser4 updates

+profile-likely-unlikely-macros-fix.patch

 Fix profile-likely-unlikely-macros.patch



All 1396 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/patch-list


