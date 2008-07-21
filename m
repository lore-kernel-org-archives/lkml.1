Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbYGURsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbYGURsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYGURsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:48:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYGURsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:48:15 -0400
Subject: [git pull] x86: declaration fixes
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 23:17:12 +0530
Message-Id: <1216662432.28271.30.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Please pull the declaration fixes for x86-tip from :

git://git.infradead.org/users/jaswinder/linux-2.6-tip.git

This includes following patches after commit 087115517d43c2 (Merge branch 'xen-64bit') :-

1. [PATCH] x86: Introducing asm/syscalls.h
2. [PATCH] x86: process_32.c declare cpu_number before they get used
3. [PATCH] x86: signal_XX.c declare do_notify_resume before they get used
4. [PATCH] x86: time_XX.c declare functions before they get used
5. [PATCH] x86: setup.c declare saved_video_mode before they get used
6. [PATCH] x86: e820.c declare pci_mem_start before they get used
7. [PATCH] x86: pci-dma.c declare iommu_bio_merge before they get used
8. [PATCH] x86: pci-nommu.c declare nommu_dma_ops before they get used
9. [PATCH] x86: i387.c declare dump_fpu() before they get used
10. [PATCH] x86: ptrace.c declare functions before they get used
11. [PATCH] x86: proc.c declare cpuinfo_op before they get used
12. [PATCH] x86: common.c declare idle_regs before they get used
13. [PATCH] x86: mtrr/main.c declare range_state as static


Thank you,

Jaswinder Singh

