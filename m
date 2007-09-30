Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbXI3XwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbXI3XwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXI3XwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:52:16 -0400
Received: from tim.rpsys.net ([194.106.48.114]:43308 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbXI3XwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:52:15 -0400
Subject: What's in linux-backlight.git for 2.6.24?
From: Richard Purdie <rpurdie@rpsys.net>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 00:52:07 +0100
Message-Id: <1191196327.6115.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've become aware that I should be posting a merge plan, probably
slightly earlier than this but better late than never.

The backlight tree doesn't have too much in it, basically a new driver,
some cleanups, a driver bugfix and a conversion of a driver to become
more generic code.

http://git.o-hand.com/?p=linux-rpurdie-backlight;a=shortlog;h=for-mm

Adrian Bunk (1):
      backlight/leds: Make two structs static

Haavard Skinnemoen (1):
      backlight: Add Samsung LTV350QV LCD driver

Jesper Juhl (1):
      backlight: Fix cr_bllcd allocations and error paths

Richard Purdie (1):
      backlight: Convert corgi backlight driver into a more generic driver

-- 
Richard

