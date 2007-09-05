Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbXIEVtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbXIEVtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 17:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbXIEVtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 17:49:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44226 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbXIEVtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 17:49:07 -0400
Date: Thu, 6 Sep 2007 03:32:15 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jean Delvare <khali@linux-fr.org>
cc: Patrick Mau <mau@oscar.ping.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Hang in 2.6.23-rc5
In-Reply-To: <20070905191145.31003be2@hyperion.delvare>
Message-ID: <alpine.LFD.0.999.0709060326430.26804@enigma.security.iitk.ac.in>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com>
 <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
 <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
 <20070902232939.f2c8acbb.francois.cami@free.fr> <20070903063904.GA1935@oscar.prima.de>
 <20070905191145.31003be2@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Sep 2007, Jean Delvare wrote:

> > On Mon, Sep 03, 2007 at 04:15:01AM +0530, Satyam Sharma wrote:
> > > That's my impression as well. That's way too core/busy a codepath to have
> > > a bug in. As I said earlier, almost anybody testing -rc5 is sure to hit
> > > this within a few hours (probably less)
> [...]
> 
> (Satyam's estimation that everybody would hit the bug within an hour

... within a *few* hours, not "an" :-)

> doesn't match my experience, I had "only" 2 freezes in 60 hours or so.)

~10 people bothered to report this on LKML -- and there could easily have
been others who didn't, and simply switched to -rc4. And then many more
might've hit it, foudn this thread immediately (like you did), and hence
didn't report again ... so I still pretty much stand by what I'd said :-)
But in any case as you said it's fixed already so no bother.
