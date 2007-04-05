Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbXDECSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbXDECSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 22:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXDECSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 22:18:45 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:54172 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbXDECSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 22:18:44 -0400
Date: Thu, 5 Apr 2007 04:15:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: David Brownell <david-b@pacbell.net>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
In-Reply-To: <20070404142607.7c0557ae.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0704050359320.22282@yvahk01.tjqt.qr>
References: <11757099691323-git-send-email-tony@atomide.com>
 <20070404120025.4c5548dc.randy.dunlap@oracle.com>
 <Pine.LNX.4.61.0704042205040.22282@yvahk01.tjqt.qr> <200704041351.19313.david-b@pacbell.net>
 <20070404142607.7c0557ae.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 4 2007 14:26, Randy Dunlap (rd) wrote:
David Brownell (db) wrote:
Jan Engelhardt (je) wrote:
je>>> 
je>>> My stance, || goes at EOL, and final ) not standalone:
db>> 
db>> You are still violating the "only TABs used for indent" rule.
rd>
rd>Yes, but CodingStyle is a just set of guidelines and common practices.
rd>It doesn't cover multi-line if () statements, which is the subject of
rd>the current controvers^W discussion.

s/Yes/No/. The example block I posted does use /^\t+/.
Mind MUAs/browsers which transform tabs into single-spaces in some cases.

>>> 	if (foo ||
>>> 	  bar ||
>>> 	  baz ||
>>> 	  etc)
>>> 		do_something;


Jan
-- 
