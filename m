Return-Path: <linux-kernel-owner+w=401wt.eu-S1422863AbXCWM4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422863AbXCWM4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 08:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422867AbXCWM4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 08:56:19 -0400
Received: from 142.163.233.220.exetel.com.au ([220.233.163.142]:36673 "EHLO
	idefix.homelinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422863AbXCWM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 08:56:18 -0400
X-Greylist: delayed 1311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Mar 2007 08:56:17 EDT
Message-ID: <4603C950.30001@usherbrooke.ca>
Date: Fri, 23 Mar 2007 23:34:24 +1100
From: Jean-Marc Valin <jean-marc.valin@usherbrooke.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM generates oops and general protection fault
References: <45B422D3.9040409@usherbrooke.ca> <1169436221.2190.13.camel@nigel.suspend2.net> <45B448BA.70800@usherbrooke.ca> <20070122132545.GA4493@ucw.cz>
In-Reply-To: <20070122132545.GA4493@ucw.cz>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry I haven't replied recently about that bug, but I have to admit I
have no idea where to start. There actually seems to be much more
fundamental problems with the kernel on my machines. I initially
realised that even without using suspend to RAM, I was still getting
crashes when docking. So I stopped docking and realised my machine would
sometimes just crash when I plug/unplug the AC adaptor. Just to give an
idea, I've experienced about 10-15 crashes in the past two months -- I
don't think I've even done a single clean shutdown during that period.

To make things worse, the behaviour is always different. Sometimes I get
a panic with keyboard LEDs flashing. Sometimes I get nothing at all and
the machine is just frozen (doesn't respond to pings or to Alt-SysRq
commands). Sometimes, I just lose my keyboard and/or mouse but the
machine stays up. I'm running a vanilla 2.6.20 kernel (not tainted) with
the following configuration: http://jmspeex.livejournal.com/1090.html

	Jean-Marc


