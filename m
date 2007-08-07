Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbXHGGIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbXHGGIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXHGGHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:07:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41004 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbXHGGHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:07:49 -0400
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
From: Arjan van de Ven <arjan@infradead.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Indan Zupancic <indan@nul.nu>, Rene Herman <rene.herman@gmail.com>,
       teresa@kvitka.net, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <F4037195-194E-4265-9653-ED964CBA41E0@mac.com>
References: <1185827130.26459.16.camel@xtower.fri>
	 <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
	 <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>
	 <46B06815.10200@gmail.com>
	 <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
	 <46B0818F.10204@gmail.com>
	 <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
	 <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com>
	 <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>
	 <F4037195-194E-4265-9653-ED964CBA41E0@mac.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 06 Aug 2007 23:05:58 -0700
Message-Id: <1186466758.2700.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 00:40 -0400, Kyle Moffett wrote:
> On Aug 01, 2007, at 11:06:00, Indan Zupancic wrote:
> > Different programs, different keys "stuck", so hard to tell. The  
> > amount the pressed key is repeated differs too, from double to  
> > hundreds.
> >
> > As an apparently separate problem my mouse warps once in a while  
> > too, and that's not totally fixed yet, neither with that locking  
> > patch. Throw in that two of my USB ports stopped working after a  
> > rare power outage, I didn't totally trust my hardware any more,  
> > hence my initial reluctance to report these problems.
> >
> > We could have independent problems with more or less the same  
> > symptoms, at least Teresa's problem seems much worse than ours, and  
> > if you and Ingo only experience a stuck delete key, it might be  
> > something else.


the last time I saw something like this it was a BIOS that kept doing
USB->PS/2 emulation even when the kernel was running.. that caused great
havoc somehow...

those who are seeing this... is it all on a USB keyboard? If so, is the
bios set to do PS/2 emulation (sometimes called USB legacy emulation) ??



