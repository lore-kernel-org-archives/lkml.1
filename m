Return-Path: <linux-kernel-owner+w=401wt.eu-S1765508AbXHDWoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765508AbXHDWoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 18:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764871AbXHDWoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 18:44:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52489 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764963AbXHDWoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 18:44:39 -0400
Date: Sun, 5 Aug 2007 00:44:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: rtc-linux@googlegroups.com
Subject: rtc max frequency setting
Message-ID: <Pine.LNX.4.64.0708050042560.14443@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


with the old rtc.ko module, there was a /proc/sys/dev/rtc/max-user-freq 
that could be set. With rtc_cmos.ko (or the new rtc infrastructure in 
general), I am missing this file. Where can I set the max-user-freq now, 
or is this obsolete now? (mplayer prefers to have user-freq to be >= 1024.)


thanks,
	Jan
-- 
