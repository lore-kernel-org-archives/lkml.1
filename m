Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbYBPOEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbYBPOEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 09:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYBPODx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 09:03:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:37418 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753857AbYBPODw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 09:03:52 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/HrCt1XVLHjEH/JeO8KIh97Flhz+NarfD7I/eWCY
	bUezUd3os4CFGB
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
From: Mike Galbraith <efault@gmx.de>
To: Gabriel C <crazy@frugalware.org>
Cc: Pavel Machek <pavel@ucw.cz>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <47B6B666.3080206@frugalware.org>
References: <200802111623.38478.elendil@planet.nl>
	 <200802130941.47163.elendil@planet.nl> <20080215235842.GA5190@ucw.cz>
	 <47B63B23.2040701@frugalware.org>
	 <1203142796.17270.11.camel@homer.simson.net>
	 <47B6B666.3080206@frugalware.org>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 15:03:48 +0100
Message-Id: <1203170628.437.12.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-16 at 11:09 +0100, Gabriel C wrote:

> Turning CONFIG_GROUP_SCHED off on this box fixes the mouse and keyboard problems. 
> ( and some other , eg: box doesn't feel 'slow' and 'laggy' anymore )

Yeah, looks like it is the same issue.  I'd suggest that folks who are
hitting this disable CONFIG_GROUP_SCHED, and flog other parts of Funky
Weasel's anatomy while it's being sorted.

	-Mike

