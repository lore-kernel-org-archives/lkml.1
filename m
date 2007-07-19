Return-Path: <linux-kernel-owner+w=401wt.eu-S936207AbXGSAhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936207AbXGSAhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbXGSAhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:37:05 -0400
Received: from 69-12-177-67.dsl.static.sonic.net ([69.12.177.67]:47270 "EHLO
	orion.sysdev.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759333AbXGSAhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:37:03 -0400
Date: Wed, 18 Jul 2007 16:37:58 -0800
From: Tony Borras <tonyb@sysdev.org>
To: linux-kernel@vger.kernel.org
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: Linux 2.4.35 tree abandoned/delayed?
Message-Id: <20070718163758.14abe65f.tonyb@sysdev.org>
In-Reply-To: <9a8748490707181710h39a4f102j36855f853f46b743@mail.gmail.com>
References: <8HOJx-2nt-21@gated-at.bofh.it>
	<8HOJx-2nt-23@gated-at.bofh.it>
	<8HOJx-2nt-25@gated-at.bofh.it>
	<8HPFA-3Pn-17@gated-at.bofh.it>
	<8I29I-6CE-21@gated-at.bofh.it>
	<20070718160309.530d2ca7.tonyb@sysdev.org>
	<9a8748490707181710h39a4f102j36855f853f46b743@mail.gmail.com>
Organization: SysDev Inc.
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i686-pc-linux-gnu)
X-Operating-System: Linux-2.6.27-SMP64
X-SlakBoot: SlakbootIBS v11.0.2
User-Agent: Sylpheed/1.0.6
X-Sylpheed-Rules: You Bet
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 02:10:58 +0200
"Jesper Juhl" <jesper.juhl@gmail.com> wrote:

> > file: patch-2.4.34.3.bz2 has the corruption at line 213:
> >   goto errout
> >
> > That is where that came from, when I patched my 2.4.34 to
> > arrive at 2.4.34.5, before applying the 2.4.35.rc5 patch!
> >
> That sounds wrong. To the best of my knowledge, the 2.4.35-rc5
> patch should be applied on top of 2.4.34, not on top of
> 2.4.34.5 ...
> 
> -- 
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post 
> http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please     
> http://www.expita.com/nomime.html

You are absolutely right!  Since I was keeping a 2.4.34.current
and 2.4.35.pre5 is just a pre, I stupidly slapped it on top at
my current build tree!

too much Summer partying!

Thanks a lot!
TonyB

There are 10 types of people in this world, those that read
binary and those who don't!

--
  __      __  _     I N C.               http://www.sysdev.org
/ __|\\// __||  \  __   __          /         tonyb@sysdev.org
\__ \ \/\__ \||)|/ O_)\/ /        \/  System Tools / Utilities
|___/ || ___/|_ /\___|\_/        WIntel / Linux Device Drivers

