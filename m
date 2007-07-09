Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXGISmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXGISmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbXGISmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:42:04 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:52192 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751815AbXGISmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:42:03 -0400
Date: Mon, 9 Jul 2007 20:42:01 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22: section mismatch warnings
Message-ID: <20070709184200.GA2496@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: arch/i386/kernel/built-in.o(.text+0xf5c1): Section mismatch: reference to .init.data:trampoline_end (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.text+0xf5c7): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.text+0xf5da): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.exit.text+0x1c): Section mismatch: reference to .init.text: (between 'cache_remove_dev' and 'ffh_cstate_exit')
WARNING: arch/i386/kernel/built-in.o(.data+0xe80): Section mismatch: reference to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mce_work')
WARNING: kernel/built-in.o(.text+0x1add5): Section mismatch: reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')

-- 
Frank
