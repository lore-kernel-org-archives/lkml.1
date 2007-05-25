Return-Path: <linux-kernel-owner+w=401wt.eu-S1764681AbXEYRuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764681AbXEYRuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763027AbXEYRuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:50:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762465AbXEYRuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:50:07 -0400
Date: Fri, 25 May 2007 13:48:25 -0400
From: Alan Cox <alan@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Newport <crn@netunix.com>,
       Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
Message-ID: <20070525174825.GA10269@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org> <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org> <20070525101105.GA9268@elte.hu> <4656CE39.8050800@netunix.com> <alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org> <20070525180304.2cc4dae0@the-village.bc.nu> <alpine.LFD.0.98.0705251012200.26602@woody.linux-foundation.org> <20070525103714.092ad631.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525103714.092ad631.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:37:14AM -0700, Andrew Morton wrote:
> Often we don't even get that: "I was in X and it didn't hit the logs".

Thats mostly solved by fixing the Oops and framebuffer code to co-operate
and is a different problem

Alan

