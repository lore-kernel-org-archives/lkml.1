Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYG2FtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYG2FtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYG2Fsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:48:55 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:55498 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbYG2Fsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:48:55 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 0/6] x86: coding style fixes to arch/x86/kernel/
Date: Tue, 29 Jul 2008 02:48:50 -0300
Message-Id: <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I removed all errors and many warnings reported by checkpatch.pl for five
files into arch/x86/kernel. I used a Linus tree with this
HEAD: 63add2f2072e69c1eb7a5f6ca8f415122da889b9 which was commited seven hours ago.

Thanks for teach me how to do this!

$ git-shortlog
Gustavo F. Padovan (6):
	x86: conding styles fixes to arch/x86/kernel/process_64.c
	x86: add KERN_INFO to printks on process_64.c
	x86: coding style fixes to arch/x86/kernel/crash_dump_64.c
	x86: coding style fixes to arch/x86/kernel/signal_64.c
	x86: coding style fixes to arch/x86/kernel/traps_64.c
	x86: coding style fixes to arch/x86/kernel/sys_x86_64.c


