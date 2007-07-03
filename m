Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXGCLAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXGCLAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXGCLAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:00:10 -0400
Received: from lucidpixels.com ([75.144.35.66]:58644 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbXGCLAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:00:08 -0400
Date: Tue, 3 Jul 2007 07:00:07 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: MTRR Patch still applies to 2.6.22-rc7.
Message-ID: <Pine.LNX.4.64.0707030659380.21706@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Incase anyone is interested:

p34:/usr/src/linux-2.6.22-rc7# patch -p1 < ../mtrr-v3.patch
patching file Documentation/kernel-parameters.txt
Hunk #1 succeeded at 548 (offset -5 lines).
patching file arch/i386/kernel/cpu/mtrr/generic.c
Hunk #2 succeeded at 85 (offset 1 line).
patching file arch/i386/kernel/cpu/mtrr/if.c
patching file arch/i386/kernel/cpu/mtrr/main.c
patching file arch/i386/kernel/cpu/mtrr/mtrr.h
patching file arch/x86_64/kernel/bugs.c
patching file arch/x86_64/kernel/setup.c
patching file include/asm-x86_64/mtrr.h
p34:/usr/src/linux-2.6.22-rc7#

