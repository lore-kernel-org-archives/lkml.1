Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbXEKMjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbXEKMjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbXEKMjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:39:32 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:48694 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbXEKMjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:39:31 -0400
Message-ID: <464463E0.1020602@freescale.com>
Date: Fri, 11 May 2007 07:38:56 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>, Simon Horman <horms@verge.net.au>,
       Timur Tabi <timur@freescale.com>,
       Kim Phillips <kim.phillips@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       =?ISO-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Kconfig warnings on latest GIT
References: <200705080004.14570.ismail@pardus.org.tr> <20070508143127.38fafa3c.kim.phillips@freescale.com> <4640D988.1040504@freescale.com> <20070510051042.GA16812@verge.net.au> <46434ED0.6030808@freescale.com> <20070511012529.GC10715@verge.net.au> <Pine.LNX.4.64.0705102046400.10555@gate.crashing.org> <20070511074337.GA3048@flint.arm.linux.org.uk>
In-Reply-To: <20070511074337.GA3048@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:

> You might also want to fix the other stupidity with this.  See my message
> on this very subject ("select is evil: another reason" from May 9th on lkml.)

I submitted a patch yesterday which includes both fixes.  Apparently, it's already in the -mm tree.
