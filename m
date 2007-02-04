Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXBDWCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXBDWCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 17:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXBDWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 17:02:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:9612 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbXBDWCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 17:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WLGXR5uJZsGnFHWxQlRfcx3E0rpQ6lElYzLlGzixoMiEHCBYG9lpRKiOMgkZAF1wQyEWu3yryrMsaRnkWgbPA6b6hdz893fN7g5CL8GsnBInXFokM7V5xH5116llf5VS2cMBB/eoEIZ9zFlfFAhrfBmeOS/A1x0hbXBrBgjSsz0=
Message-ID: <a44ae5cd0702041402g14051b58qfeb270a72123e22e@mail.gmail.com>
Date: Sun, 4 Feb 2007 14:02:06 -0800
From: "Miles Lane" <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.20 -- Loads of section mismatches
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Are any of these worth fixing?

WARNING: vmlinux - Section mismatch: reference to
.init.data:boot_params from .text between '_text' (at offset
0xc0100036) and 'checkCPUtype'
WARNING: vmlinux - Section mismatch: reference to
.init.data:boot_params from .text between '_text' (at offset
0xc0100044) and 'checkCPUtype'
WARNING: vmlinux - Section mismatch: reference to
.init.data:init_pg_tables_end from .text between '_text' (at offset
0xc01000a6) and 'checkCPUtype'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc01000d5) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc01000df) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc01000fe) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc010010f) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc0100115) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc010011b) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc0100121) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc0100137) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc0100141) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc010014a) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'checkCPUtype' (at offset
0xc0100150) and 'is486'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'check_x87' (at offset
0xc01001b4) and 'setup_pda'
WARNING: vmlinux - Section mismatch: reference to
.init.data:new_cpu_data from .text between 'check_x87' (at offset
0xc01001d2) and 'setup_pda'
WARNING: vmlinux - Section mismatch: reference to
.init.text:start_kernel from .text between 'is386' (at offset
0xc01001ae) and 'check_x87'
WARNING: vmlinux - Section mismatch: reference to
.init.text:spawn_ksoftirqd from .text between 'init' (at offset
0xc0100392) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:spawn_softlockup_task from .text between 'init' (at offset
0xc0100397) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:APIC_init_uniprocessor from .text between 'init' (at offset
0xc010039c) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:sched_init_smp from .text between 'init' (at offset
0xc01003a1) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:usermodehelper_init from .text between 'init' (at offset
0xc01003ab) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:driver_init from .text between 'init' (at offset
0xc01003b0) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:sysctl_init from .text between 'init' (at offset
0xc01003b5) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to .init.data: from
.text between 'init' (at offset 0xc01003cf) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to .init.data: from
.text between 'init' (at offset 0xc010040d) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:prepare_namespace from .text between 'init' (at offset
0xc01004e5) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to
.init.text:lockdep_init from .text between 'lockdep_init_map' (at
offset 0xc012e6a9) and 'save_trace'
WARNING: vmlinux - Section mismatch: reference to
.init.text:lockdep_init from .text between 'lockdep_reset_lock' (at
offset 0xc012f3fb) and 'lockdep_off'
WARNING: vmlinux - Section mismatch: reference to
.init.text:lockdep_init from .text between '__lock_acquire' (at offset
0xc01304e4) and 'lock_acquire'
WARNING: vmlinux - Section mismatch: reference to
.init.text:__alloc_bootmem_node from .text between
'init_currently_empty_zone' (at offset 0xc013f92a) and
'free_area_init_node'
WARNING: vmlinux - Section mismatch: reference to
.init.text:zone_spanned_pages_in_node from .text between
'free_area_init_node' (at offset 0xc013fa12) and 'build_all_zonelists'
WARNING: vmlinux - Section mismatch: reference to
.init.text:zone_absent_pages_in_node from .text between
'free_area_init_node' (at offset 0xc013fa3c) and 'build_all_zonelists'
WARNING: vmlinux - Section mismatch: reference to
.init.text:zone_spanned_pages_in_node from .text between
'free_area_init_node' (at offset 0xc013fadb) and 'build_all_zonelists'
WARNING: vmlinux - Section mismatch: reference to
.init.text:zone_absent_pages_in_node from .text between
'free_area_init_node' (at offset 0xc013faec) and 'build_all_zonelists'
WARNING: vmlinux - Section mismatch: reference to .init.data: from
.text between 'free_area_init_node' (at offset 0xc013fb43) and
'build_all_zonelists'
WARNING: vmlinux - Section mismatch: reference to
.init.text:__alloc_bootmem_node from .text between 'sparse_init' (at
offset 0xc01515b2) and '__section_nr'
WARNING: vmlinux - Section mismatch: reference to
.init.data:initkmem_list3 from .text between 'set_up_list3s' (at
offset 0xc0154b74) and 'poison_obj'
WARNING: vmlinux - Section mismatch: reference to
.init.text:__alloc_bootmem from .text between 'vgacon_startup' (at
offset 0xc01f873b) and 'vgacon_scrolldelta'
WARNING: vmlinux - Section mismatch: reference to
.init.data:logo_linux_clut224 from .text between 'fb_find_logo' (at
offset 0xc01febff) and 'cfb_fillrect'
WARNING: vmlinux - Section mismatch: reference to .init.text: from
.text between 'iret_exc' (at offset 0xc02d11ae) and '_etext'
WARNING: vmlinux - Section mismatch: reference to
.init.text:start_kernel from .paravirtprobe between
'__start_paravirtprobe' (at offset 0xc03a24c4) and
'__stop_paravirtprobe'
