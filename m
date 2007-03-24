Return-Path: <linux-kernel-owner+w=401wt.eu-S1751200AbXCXLmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbXCXLmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 07:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXCXLmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 07:42:09 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40216 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbXCXLmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 07:42:08 -0400
Date: Sat, 24 Mar 2007 12:42:04 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Fan control disabled
Message-ID: <Pine.LNX.4.61.0703241218410.10028@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


for some reason, pwm (fan control) is not writable

11:30 linux-si2r:../i2c-1/1-002e # l pwm*_enable
-r--r--r-- 1 root root 4096 Mar 24 11:19 pwm1_enable
-r--r--r-- 1 root root 4096 Mar 24 11:19 pwm2_enable
-r--r--r-- 1 root root 4096 Mar 24 11:19 pwm3_enable
11:30 linux-si2r:../i2c-1/1-002e # pwd
/sys/devices/pci0000:00/0000:00:01.1/i2c-1/1-002e

Any directions on where to go from here?

Thanks,
Jan
-- 
