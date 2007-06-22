Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbXFVUzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbXFVUzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXFVUzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:55:07 -0400
Received: from 1wt.eu ([62.212.114.60]:3095 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbXFVUzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:55:06 -0400
Date: Fri, 22 Jun 2007 22:54:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?Zolt=E1n?= HUBERT <zoltan.hubert@zzaero.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070622205456.GW943@1wt.eu>
References: <200706212349.54983.zoltan.hubert@zzaero.com> <20070621230858.2a0b1369@the-village.bc.nu> <200706220021.51266.zoltan.hubert@zzaero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706220021.51266.zoltan.hubert@zzaero.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 12:21:51AM +0200, Zoltán HUBERT wrote:
> On Friday 22 June 2007 00:08, you wrote:
> > > So I feel that a turning-point is coming where a really
> > > really really (x 15) stable and reliable kernel is
> > > NEEDED.
> >
> > Its incredibly hard to keep a stable kernel side API/ABI
> > by just backporting fixes. Fortunately you can pay
> > vendors to do this for you and provide support, or if you
> > just want the bits run stuff like Centos
> 
> Thanks Alan,
> 
> but there was a time when a british bearded person did that 
> just fine. Later a haired Brazilian did it fine too. Now 
> that BIG bu$ine$$e$ are in the game shouldn't it be 
> easier ?

Big businesses place their money where there are customers.
People maintaining stable releases do that because they use
them on some long term projects or because they want to do
it by conviction, but in both cases, there are very few, if
any at all, $$ involved.

For 2.4, I'm in the first category (used in products). But
I will not do this all my life (unless it ends sooner than
expected). After I do not use it, I will most probably
continue in the second category, then someday declare it
"out of support", perhaps when there will be no patch for
one year.

I think that Adrian Bunk directly started in the second
category with 2.6.16 (by conviction). And BTW, you were
not fair saying that 2.6.x.y are semi-stable and semi-
supported. 2.6.16 has been maintained for more than one
year now, and in my opinion, it is a success.

> PS: Centos ? WTF ?

it's a repackaging from Red Hat Enterprise sources. So you
have the long time fixes, and you can selfishly keep your
money for you without supporting any of the big businesses
in the game which ought to make it easier ...

Willy

