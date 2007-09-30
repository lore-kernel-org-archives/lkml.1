Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbXI3Xwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbXI3Xwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXI3XwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:52:20 -0400
Received: from tim.rpsys.net ([194.106.48.114]:43311 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbXI3XwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:52:19 -0400
Subject: What's in linux-leds.git for 2.6.24?
From: Richard Purdie <rpurdie@rpsys.net>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 00:52:10 +0100
Message-Id: <1191196330.6115.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've become aware that I should be posting a merge plan, probably
slightly earlier than this but better late than never.

The leds tree doesn't have much in it, basically some changes to the
cobalt LED drivers.

http://git.o-hand.com/?p=linux-rpurdie-leds;a=shortlog;h=for-mm

Yoichi Yuasa (3):
      leds: Rename leds-cobalt driver
      leds: Add Cobalt Raq series LEDs support
      leds: Update Cobalt Qube series front LED support

-- 
Richard

