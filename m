Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbYDWFVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbYDWFVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYDWFVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:21:14 -0400
Received: from smtp.enter.net ([216.193.128.24]:1661 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYDWFVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:21:13 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: x86: 4kstacks default
Date: Wed, 23 Apr 2008 01:21:10 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Romano Giannetti <romanol@upcomillas.es>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <1208888454.10279.7.camel@localhost> <200804230703.11816.vda.linux@googlemail.com>
In-Reply-To: <200804230703.11816.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804230121.11004.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008 01:03:11 Denys Vlasenko wrote:
> On Tuesday 22 April 2008 20:20, Romano Giannetti wrote:
> > On Sun, 2008-04-20 at 11:44 -0400, Daniel Hazelton wrote:
> > > Since the second-most-common reason for stack overages is
> > > ndiswrapper... Well, with there being so much more hardware now
> > > supported directly by the linux kernel...
> >
> > How would I like you being right... Atheros AR5008, AR5414 PHY, "not yet
> > here". It's almost one year now since I bought this laptop, and till now
> > it's the cable or ndiswrapper. But yes, it's going better. For my first
> > wifi laptop I waited two and a half years, now it seems that in a bit
> > more than one there will be an open source driver...
> >
> > I know all the trouble ndiswrapper signify. But I see also that people
> > around me with a laptop and linux use more ndiswrapper than a real
> > driver, so... be gentle with it.
>
> Nobody knows how much potential development is not done because
> "you can make your wifi work with ndiswrapper".

I've got to agree with that sentiment. Once a working solution is found, no 
matter how crappy, it seems that almost all development stops.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
