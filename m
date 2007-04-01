Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbXDASNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbXDASNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933760AbXDASNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:13:37 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:38762 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbXDASNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:13:37 -0400
Date: Sun, 1 Apr 2007 20:13:37 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/16] Assorted patches
Message-ID: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,


People collect stamps, etc. and I do patches. It is April 01, but let ye 
know that even the patch that would get the most naks is not really 
meant as an April joke.
Most of them are independent, but I'll let `quilt graph` judge their 
dependencies.

	[01/] vt-sysfs-for-colors.diff
	[02/] vt-pure-colors.diff
	[03/] vt-underline-color.diff
	[04/] vt-printk-color.diff
	[05/] fix-kthread-niceness.diff
	[06/] isofs-add-write-bit.diff
	[07/] kconfig-dynamic-frequency.diff
	[08/] console-printk-level.diff
	[09/] zlib-decompression-status.diff
	[10/] show-partitions-on-mount-error.diff
	[11/] samba-eintr-fix.diff
	[12/] cifs-use-mutex.diff
	[13/] show-pipesize-in-stat.diff
	[14/] kconfig-allow-override.diff
	[15/] use-regular-eth-suffix.diff
	[16/] warn-on-kthread-name-truncation.diff

(`quilt graph` says the order of the vt-* ones is important.)


Jan
-- 
