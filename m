Return-Path: <linux-kernel-owner+w=401wt.eu-S1423342AbXBPGUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423342AbXBPGUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423341AbXBPGUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:20:05 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:4098 "EHLO
	pd5mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423339AbXBPGUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:20:03 -0500
Date: Thu, 15 Feb 2007 21:59:06 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
In-reply-to: <20070215215125.9161e3dc.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <Pine.LNX.4.64.0702152158210.12571@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
 <20070215205658.56096f97.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702152134190.12571@montezuma.fsmlabs.com>
 <20070215214506.f795acc4.akpm@linux-foundation.org>
 <20070215215125.9161e3dc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Andrew Morton wrote:

> On Thu, 15 Feb 2007 21:45:06 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 15 Feb 2007 21:35:35 -0800 (PST) Zwane Mwaikambo <zwane@infradead.org> wrote:
> > 
> > > On Thu, 15 Feb 2007, Andrew Morton wrote:
> > > 
> > > > This makes the long-suffering-but-vigorously-defended Vaio come up with a
> > > > black display.  Everything's working OK otherwise.  Sort of a Black Screen
> > > > of Life.  I wouldn't call it an improvement though.
> > > 
> > > Bugger, what does your kernel commandline look like?
> > 
> > Kernel command line: ro root=LABEL=/ rhgb vga=0x263 clock=pit
> 
> Removing the vga=0x263 "fixes" it.
> 

Sorry i missed this earlier, could you also post up an Xorg.0.log (or 
equivalent for your system).

Thanks,
	Zwane
