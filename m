Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbXFPHUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbXFPHUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXFPHUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:20:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbXFPHUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:20:41 -0400
Date: Sat, 16 Jun 2007 00:19:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>
Subject: Re: Jinxed VAIO wreckage - current state of affairs
Message-Id: <20070616001942.475c8beb.akpm@linux-foundation.org>
In-Reply-To: <1181976813.8176.365.camel@chaos>
References: <1181418873.4404.402.camel@chaos>
	<200706092259.50694.rjw@sisk.pl>
	<20070609200827.635fec79.akpm@linux-foundation.org>
	<1181909157.8176.342.camel@chaos>
	<20070615082324.203610ec.randy.dunlap@oracle.com>
	<1181921466.8176.356.camel@chaos>
	<20070615233138.78a79b00.akpm@linux-foundation.org>
	<1181976453.8176.362.camel@chaos>
	<1181976813.8176.365.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007 08:53:33 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> > Still I can not explain, why this resulted in this strange "disappear in
> > the return instruction" behavior.
> 
> I put up a fixed patch series against rc4-mm to:
> 
> http://www.tglx.de/projects/hrtimers/2.6.22-rc4-mm2/patch-2.6.22-rc4-mm2-hrt3.patches.tar.bz2

I expect that everyone's forgotten what they do.  It wouldn't hurt to send
them all out in the usual fashion.

btw, I have a huge backlog here (almost two days' worth!) and I'll be only
intermittently up for a couple of weeks.  There will be some delays,
sorry.  
