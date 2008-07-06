Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYGFFZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYGFFZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 01:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYGFFZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 01:25:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29774 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYGFFZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 01:25:47 -0400
Date: Sat, 5 Jul 2008 22:17:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Matthew Wilcox" <matthew@wil.cx>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jan Engelhardt" <jengelh@medozas.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: the printk problem
Message-Id: <20080705221719.949998e5.randy.dunlap@oracle.com>
In-Reply-To: <84144f020807051702q1fc6275cv358c5e33dc2677fc@mail.gmail.com>
References: <20080705125230.GA20166@damson.getinternet.no>
	<alpine.LFD.1.10.0807051045520.2815@woody.linux-foundation.org>
	<19f34abd0807051141h4ccfd0ar28660199f2bbf81f@mail.gmail.com>
	<20080705185253.GQ14894@parisc-linux.org>
	<84144f020807051702q1fc6275cv358c5e33dc2677fc@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 03:02:59 +0300 Pekka Enberg wrote:

> On Sat, Jul 05, 2008 at 08:41:39PM +0200, Vegard Nossum wrote:
> >> Single letters are bad because it hurts readability and limits the
> >> usefulness of the extension.</MHO>
> 
> On Sat, Jul 5, 2008 at 9:52 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > I think you need a little warning noise that goes off in your head that
> > means "I might be overdesigning this".  Linus' code is elegant and
> > solves a problem nicely.
> 
> Am I the only one who missed Linus' patch? Did it make it to the list?

No, you are not the only one.  It was on linuxppc-dev for some reason.
http://ozlabs.org/pipermail/linuxppc-dev/2008-July/059257.html

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
