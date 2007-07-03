Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbXGCMSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbXGCMSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbXGCMSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:18:39 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36325 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbXGCMSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:18:38 -0400
Date: Tue, 3 Jul 2007 14:18:37 +0200
To: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: recognizing memory sticks in tifm
Message-ID: <20070703121836.GD13122@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex, hi all,

I have an Acer TM3012 with
0a:09.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)

but only when I plug in an SD card I get a device created, while
plugging in a Memory Stick I do not get any reaction of the kernel.

This is with kernel 2.6.22-rc6.

Is this feature missing or could it be a configuration error (.config if
you need it).

Inserting a sd card gives:
tifm_core: MMC/SD card detected in socket 0:1
mmcblk0: mmc0:bffc SD02G 1985024KiB 
 mmcblk0: p1

>From the "MMC/SD card detected" I assumed that MS should work, too.

Thanks for any clarification.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
MAENTWROG (n. Welsh)
The height by which the top of a wave exceeds the heigh to which you
have rolled up your trousers.
			--- Douglas Adams, The Meaning of Liff
