Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbXGKPPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbXGKPPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761090AbXGKPPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:15:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:13271 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759926AbXGKPPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:15:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HCBYWWxaWFHBv75KfbB2RwLGv30PoNEngM4UJ12P8Nwkb4muwYTCb3szoIO2KsKpR11lajqdEZQSGzG47rfJX+AB1ocT1xUQwnf+GIkTttn2UdfqNGoTbyFGMTiWlsO3WcukAJoiOkd6D8edDjhiMaohAHQRfxv4fEyRmg8ZNZc=
Message-ID: <75b57c110707110815m4ffb2262p374848b2310b2cc9@mail.gmail.com>
Date: Wed, 11 Jul 2007 11:15:04 -0400
From: "Gerb Stralko" <gerb.stralko@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Gmail and flowed text (was Re: Correction to LZO1X)
Cc: "Nitin Gupta" <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       "Jesper Juhl" <jesper.juhl@gmail.com>
In-Reply-To: <a781481a0707110811k7b9fd322t9fff2ff23d9c6135@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707110636l3b56a25j174603a5a8af3186@mail.gmail.com>
	 <9a8748490707110641y1796d5dy42d4f744f131fbc9@mail.gmail.com>
	 <75b57c110707110652h24166093ra063731f0c2a90a2@mail.gmail.com>
	 <a781481a0707110724s11cc51c4p1ed54466945258f3@mail.gmail.com>
	 <a781481a0707110811k7b9fd322t9fff2ff23d9c6135@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

do you have ssh access?  if so, setup a linux machine outside of this
evil network and ssh into it.  ssh is pretty configurable to get
around firewalls/nats.

enjoy

On 7/11/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 7/11/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > Hi,
> >
> > On 7/11/07, Gerb Stralko <gerb.stralko@gmail.com> wrote:
> > [...]
> > > This link will help:
> > > http://www.ii.com/internet/messaging/pine/pc/#gmail
> > >
> > > Scroll down untill you see a yellow box section that say:
> > > Gmail Tips
> > >     * If you want to use the Gmail SMTP server for your outgoing
> > > messages, I recommend that you create a Pine Role that includes these
> > > ACTIONS:
> >
> > Ok, I read through the relevant bits of that page, thanks. My box
> > here doesn't resolve smtp.gmail.com / pop.gmail.com and there
> > could be firewalling issues on top of that, so I'm not too hopeful ...
> > but I'll give it a try definitely.
>
> I tried adding the IP address for {smtp,pop}.gmail.com directly to
> my /etc/hosts, finally just substituted with the IP address itself in
> pine (as suggested on that link), but couldn't connect. I should've
> expected, with the evil NAT setup that I mentioned earlier ... all
> boxes here have private addresses (only) assigned to them, and
> connect to the outside world via a (squid/web) proxy ... Ick.
> [The proxy does allow CONNECT so some hope is left still.]
>
> Thanks for suggestions,
>
> Satyam
>
