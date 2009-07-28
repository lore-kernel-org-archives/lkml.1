Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbZG1T5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbZG1T5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZG1T5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:57:46 -0400
Received: from kroah.org ([198.145.64.141]:50339 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZG1T5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:57:45 -0400
Date: Tue, 28 Jul 2009 12:56:48 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090728195648.GA4833@kroah.com>
References: <87r5w19xsb.fsf@devron.myhome.or.jp>
 <20090728112203.7b70adba@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
 <20090728174213.5e927428@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
 <20090728180649.596c5412@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
 <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
 <20090728201553.0eb2d51d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728201553.0eb2d51d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 08:15:53PM +0100, Alan Cox wrote:
> 
> > Quite frankly, I don't understand why I should even have to bring these 
> > issues up. You should have tried to fix the problem immediately, without 
> > arguing against fixing the kernel. Without blaming user space. Without 
> > making idiotic excuses for bad kernel behavior.
> > 
> > The fact is, breaking regular user applications is simply not acceptable. 
> > Trying to blame kernel breakage on the app being "buggy" is not ok. And 
> > arguing for almost a week against fixing it - that's just crazy.
> 
> I've been working on fixing it. I have spent a huge amount of time
> working on the tty stuff trying to gradually get it sane without breaking
> anything and fixing security holes along the way as they came up. I spent
> the past two evenings working on the tty regressions.
> 
> However I've had enough. If you think that problem is easy to fix you fix
> it.
> 
> Have fun.
> 
> I've zapped the tty merge queue so anyone with patches for the tty layer
> can send them to the new maintainer.

Do you have a pointer to your previous queue before you zapped it so
that others might be able to pick it up?

thanks,

greg k-h
