Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXGATsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXGATsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 15:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbXGATr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 15:47:59 -0400
Received: from mail.screens.ru ([213.234.233.54]:36619 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbXGATr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 15:47:58 -0400
Date: Sun, 1 Jul 2007 23:47:59 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Mack <daniel@qanu.de>,
       Holger Waechtler <holger@qanu.de>
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070701194759.GA269@tv-sign.ru>
References: <4683F48F.9010603@gmx.de> <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de> <20070629130955.GA284@tv-sign.ru> <20070629131605.GA25964@elte.hu> <20070629135848.GA332@tv-sign.ru> <1183152090.7089.183.camel@gaivota> <d9def9db0706291434v2fe69578qf84488bfd6a965f3@mail.gmail.com> <20070630141928.GA5182@tv-sign.ru> <4687F883.1000007@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4687F883.1000007@gmx.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Thomas Sattler wrote:
>
> > Thomas, any chance you could try the patch below? It is very, very stupid,
> > it was done without any understanding of this code, and of course it is
> > completely untested. I doubt very much it is correct, and even if it is
> > correct it is definitely not good. It would be great if Dmitry can take a look.
> 
> I'm still testing but I couldn't break it until now.
> And I didn't find any drawbacks yet.

Great, thanks a lot Thomas!

I'll re-send the patch tomorrow with a proper changelog unless you find
something else or maintainers have any objections.

Oleg.

