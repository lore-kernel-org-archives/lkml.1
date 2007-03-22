Return-Path: <linux-kernel-owner+w=401wt.eu-S934012AbXCVT15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbXCVT15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934190AbXCVT14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:27:56 -0400
Received: from mta01.charter.net ([209.225.8.181]:61471 "EHLO
	mtai01.charter.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934012AbXCVT1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:27:55 -0400
Message-ID: <1992941410.1174591674270.JavaMail.root@fepweb09>
Date: Thu, 22 Mar 2007 11:27:54 -0800
From: <genestapp@charter.net>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA: Marvell 88SE6141 kernel support?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Sensitivity: Normal
X-Originating-IP: from 74.138.202.34 by mail.charter.net; Thu, 22 Mar 2007 15:27:54 -0400
X-Chzlrs: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sorry about it taking so long to get back to you. I noticed it still doesn't 
work after upgrading to fedora 6 and the newest kernel (at the time) so I thought I'd give your legacy driver a try (if you 
still have it) I'd love to have those 4 extra sata ports. Just a question with 
the legacy driver would the performance take a hit? I'd be using the ports to 
add more disks to raid arrays. 

kernel version: 2.6.19-1.2911.6.5.fc6:
linux distro: fedora core 6 64bit
lspci -v output for marvell sata - 

03:00.0 SATA controller: Marvell Technology Group Ltd. Unknown device 6141 (rev 01) (prog-if 81)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81d6
        Flags: bus master, fast devsel, latency 0, IRQ 10
        I/O ports at 9c00 [size=8]
        I/O ports at 9880 [size=4]
        I/O ports at 9800 [size=64]
        I/O ports at 9480 [size=32]
        Memory at fa5ffc00 (32-bit, non-prefetchable) [size=1K]
        Expansion ROM at fa580000 [disabled] [size=256K]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
        Capabilities: [e0] Express Legacy Endpoint IRQ 0 

Gene

