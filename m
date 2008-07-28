Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYG1VJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYG1VJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYG1VJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:33 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49588 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYG1VJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:32 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 0/24] x86: arch/x86/kernel/ cleanups
Date: Mon, 28 Jul 2008 18:09:07 -0300
Message-Id: <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,


Ingo,

I removed many extra whitespaces and tabs from arch/x86/kernel/


$ git-shortlog
Gustavo F. Padovan (24):
	x86: kernel/alternative.c cleanup
	x86: kernel/apm_32.c cleanup
	x86: kernel/asm-offsets_64.c cleanup
	x86: kernel/efi.c cleanup
	x86: kernel/cpuid.c cleanup
	x86: kernel/early-quirks.c cleanup
	x86: kernel/io_apic_32.c cleanup
	x86: kernel/io_apic_64.c cleanup
	x86: kernel/irq_64.c cleanup
	x86: kernel/irqinit_32.c cleanup
	x86: kernel/kprobes.c cleanup
	x86: kernel/microcode.c cleanup
	x86: kernel/module_64.c cleanup
	x86: kernel/pci-calgary_64.c cleanup
	x86: kernel/probe_roms_32.c cleanup
	x86: kernel/process_32.c cleanup
	x86: kernel/process_64.c cleanup
	x86: kernel/signal_64.c cleanup
	x86: kernel/traps_64.c cleanup
	x86: kernel/tsc.c cleanup
	x86: kernel/visws_quirks.c cleanup
	x86: kernel/vmi_32.c cleanup
	x86: kernel/vmiclock_32.c cleanup
	x86: kernel/sys_x86_64.c cleanup




