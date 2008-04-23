Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbYDWFlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbYDWFlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYDWFlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:41:13 -0400
Received: from smtp.enter.net ([216.193.128.24]:3764 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbYDWFlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:41:12 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: david@lang.hm
Subject: Re: x86: 4kstacks default
Date: Wed, 23 Apr 2008 01:41:09 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Romano Giannetti <romanol@upcomillas.es>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <200804230121.11004.dhazelton@enter.net> <alpine.DEB.1.10.0804222222490.23325@asgard>
In-Reply-To: <alpine.DEB.1.10.0804222222490.23325@asgard>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804230141.09523.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008 01:25:27 david@lang.hm wrote:
> On Wed, 23 Apr 2008, Daniel Hazelton wrote:
> > On Wednesday 23 April 2008 01:03:11 Denys Vlasenko wrote:
> >> On Tuesday 22 April 2008 20:20, Romano Giannetti wrote:
> >>> On Sun, 2008-04-20 at 11:44 -0400, Daniel Hazelton wrote:
> >>>> Since the second-most-common reason for stack overages is
> >>>> ndiswrapper... Well, with there being so much more hardware now
> >>>> supported directly by the linux kernel...
> >>>
> >>> How would I like you being right... Atheros AR5008, AR5414 PHY, "not
> >>> yet here". It's almost one year now since I bought this laptop, and
> >>> till now it's the cable or ndiswrapper. But yes, it's going better. For
> >>> my first wifi laptop I waited two and a half years, now it seems that
> >>> in a bit more than one there will be an open source driver...
> >>>
> >>> I know all the trouble ndiswrapper signify. But I see also that people
> >>> around me with a laptop and linux use more ndiswrapper than a real
> >>> driver, so... be gentle with it.
> >>
> >> Nobody knows how much potential development is not done because
> >> "you can make your wifi work with ndiswrapper".
> >
> > I've got to agree with that sentiment. Once a working solution is found,
> > no matter how crappy, it seems that almost all development stops.
>
> and nobody knows how many people are running linux instead of windows
> becouse they were able to use ndiswrapper to get things running. most of
> those people contributed nothing to the kernel, but they all contributed
> to Linux, if nothing else as examples that Linux is a reasonable option
> (and some percentage of those users have contrinbuted to other opensource
> projects that they would probably never have bumped into if they were
> running windows instead)
>
> I know we will never convince each other, but we do need to recognise that
> there is another valid point of view.

And who knows how many more people would be running Linux if they didn't need 
ndiswrapper at all?

And how much better would it be if the drivers were native linux code and were 
fully supportable because of that?

There are many, many reasons why it'd be better if ndiswrapper didn't exist as 
a solution or if development on native solutions continued on at the level it 
would without ndiswrapper. 

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
