Return-Path: <linux-kernel-owner+w=401wt.eu-S1422768AbXEDALz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768AbXEDALz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423471AbXEDALz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:11:55 -0400
Received: from 1wt.eu ([62.212.114.60]:2482 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422768AbXEDALy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:11:54 -0400
Date: Fri, 4 May 2007 02:11:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: =?iso-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
Message-ID: <20070504001147.GA31125@1wt.eu>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com> <20070503205341.GB943@1wt.eu> <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr> <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com> <20070503222334.GD943@1wt.eu> <Pine.LNX.4.61.0705040049520.18504@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705040049520.18504@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 12:50:17AM +0200, Jan Engelhardt wrote:
> 
> On May 4 2007 00:23, Willy Tarreau wrote:
> >
> >> This setup will only run for about 1-2 hours while we fix the hardware
> >> router (it is running now, but only on a backup flash card solution.
> >> the harddrive in it died ;)
> >
> >Huhhh! Please tell us exactly what make and model of ROUTER you are using
> >which embeds a HARD DRIVE, so that we recall never to buy that ! Having
> >seen uptimes of 5 years on moderately big access routers, I would have
> >find it awful to see them die multiple times in that timeframe because
> >of a crappy IDE drive inside !
> 
> Haha. Would you be happy if it ran on a CF card instead? :>

Yes, because at least when you design a system to run on a CF card, you
ensure never to write on it because you know that would kill it. Then
since you never write on it, it does not wear out and has no problem
running for years (unless you bought cheap end-user CF of course). But
industrial-grade CF *is* reliable for such usages. People having problems
with CF are dumb asses who install a full standard system on those
(sometimes even with swap) then complain it dies after one year.

A hard disk simply fails after some time even if you never use it at all.
A head flying 10 microns above a platter passing at 33 m/s obviously likes
to caress it sometimes, with a polite "oops sorry" excuse that you hear
meters away.

That's a pretty bad design to put such a SPOF in some equipment which IMHO
has no real justification for embedding one, really.

Cheers,
Willy

