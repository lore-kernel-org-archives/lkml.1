Return-Path: <linux-kernel-owner+w=401wt.eu-S1161133AbXDEERM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161133AbXDEERM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 00:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161137AbXDEERM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 00:17:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43530 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161133AbXDEERL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 00:17:11 -0400
Message-ID: <46147888.2080507@oracle.com>
Date: Wed, 04 Apr 2007 21:18:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: David Brownell <david-b@pacbell.net>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
References: <11757099691323-git-send-email-tony@atomide.com> <20070404120025.4c5548dc.randy.dunlap@oracle.com> <Pine.LNX.4.61.0704042205040.22282@yvahk01.tjqt.qr> <200704041351.19313.david-b@pacbell.net> <20070404142607.7c0557ae.randy.dunlap@oracle.com> <Pine.LNX.4.61.0704050359320.22282@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704050359320.22282@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 4 2007 14:26, Randy Dunlap (rd) wrote:
> David Brownell (db) wrote:
> Jan Engelhardt (je) wrote:
> je>>> 
> je>>> My stance, || goes at EOL, and final ) not standalone:
> db>> 
> db>> You are still violating the "only TABs used for indent" rule.
> rd>
> rd>Yes, but CodingStyle is a just set of guidelines and common practices.
> rd>It doesn't cover multi-line if () statements, which is the subject of
> rd>the current controvers^W discussion.
> 
> s/Yes/No/. The example block I posted does use /^\t+/.
> Mind MUAs/browsers which transform tabs into single-spaces in some cases.
> 
>>>> 	if (foo ||
>>>> 	  bar ||
>>>> 	  baz ||
>>>> 	  etc)
>>>> 		do_something;

I don't think it's a MUA thing.  I think David is talking about the
spaces after the ^\t that are used for indenting immediately under
the "if".

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
