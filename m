Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYACQ6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYACQ6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYACQ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:58:34 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:52934 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYACQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:58:33 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org
Cc: david-b@pacbell.net, tony@atomide.com
Subject: [PATCH 0/2] ISP1301 updates
Date: Thu,  3 Jan 2008 11:59:55 -0500
Message-Id: <1199379597-6273-1-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.5.4.rc1.21.g0e545-dirty
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello all,

The following two patches updates isp1301_omap.c to new-style i2c driver.
The patches are against curent linux mailine head.

Tony Lindgren (Cc'ed here) already has a working version of this driver
on his linux-omap git tree (see [1] and [2]), these are just a rework for
them to apply cleanly on mainline.

The patches were compile tested with omap_h2_1610_defconfig with isp1301
enabled.


[1] http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=commit;h=d8e0e848e562deaa405a2014240d6deedf3bfd37
[2] http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=commit;h=d24c8950a363044016679cdf76435abdace2f56d

BR,

Felipe Balbi

