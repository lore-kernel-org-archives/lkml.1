Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYDMTX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYDMTX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYDMTXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:23:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36805 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbYDMTXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:23:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Sergio Luis" <sergio@uece.br>
Subject: Re: 2.6.25-rc8: FTP transfer errors
Date: Sun, 13 Apr 2008 21:24:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "David Miller" <davem@davemloft.net>, w@1wt.eu, johnpol@2ka.mipt.ru,
       lkml@rtr.ca, ilpo.jarvinen@helsinki.fi, jesper.juhl@gmail.com,
       tilman@imap.cc, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20080411151821.GA32398@2ka.mipt.ru> <200804132015.21742.rjw@sisk.pl> <ce0170d90804131151ia99147bv9ad12e625191be5e@mail.gmail.com>
In-Reply-To: <ce0170d90804131151ia99147bv9ad12e625191be5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804132124.09903.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 of April 2008, Sergio Luis wrote:
> On Sun, Apr 13, 2008 at 3:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, 12 of April 2008, David Miller wrote:
> >  > From: Willy Tarreau <w@1wt.eu>
> >  > Date: Sat, 12 Apr 2008 10:44:00 +0200
> >  >
> >  > > While it is a powerful tool, we must accept that it cannot efficiently
> >  > > work in some circumstances, such as :
> >  >
> >  > Everyone is well aware of all of this, that's why I specifically asked
> >  > for a bisect, because I knew it would be crucial to pinpointing this
> >  > particular bug.
> >  >
> >  > And lo' and behold in 15 minutes after the bisect results were
> >  > available it got fixed.
> >
> >  I can't find the fix, btw.  Can you please point me to it?
> 
> there you go
> http://lkml.org/lkml/2008/4/10/409
> http://lkml.org/lkml/2008/4/10/410

Thanks a lot,
Rafael
