Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXD3LD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXD3LD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbXD3LD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:03:56 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52905 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbXD3LDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:03:55 -0400
Date: Mon, 30 Apr 2007 13:03:02 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/36] Use menuconfig objects II - (overview)
Message-ID: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,


here is the second run of use-menuconfig-objects patches that make
more menus use, well, the "menuconfig" objects. The series, which
goes on top of mm-broken-out-20070428, includes:

  * 1 patch to fix up a remainder of the first run

  * 35 patches to change to menuconfigs


Jan
-- 
