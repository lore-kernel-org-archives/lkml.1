Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbYHFPi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbYHFPi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbYHFPdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:33:35 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:11288 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756163AbYHFPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:33:33 -0400
X-BigFish: VPS1(z5edJzzz10d3izz2f39iz32i61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K56R70-02-ZRR-01
Message-ID: <20080806152117.198754464@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 6 Aug 2008 17:21:17 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch 0/5] x86-microcode: run ucode update via workqueue
X-OriginalArrivalTime: 06 Aug 2008 15:32:09.0978 (UTC) FILETIME=[97619DA0:01C8F7D9]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Referring to: http://lkml.org/lkml/2008/8/3/114
Dmitry, thanks for your work.

Rebased Dmitry's patch set to x86-microcode and incorporated changes into AMD microcode patch loader. No issues with
cpu-hotplug anymore, tested on Intel as well as AMD.

--Peter




