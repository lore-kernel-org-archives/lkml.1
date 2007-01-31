Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbXAaCLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbXAaCLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXAaCLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:11:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:29301 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbXAaCLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oIgFx0/Hz9Gg6FAAxS+v2cRxeo5lv7zQ6tL29EVHo10iuzundanV8azHcxDkFMplSrqcymxWviEAIiOQA9xahZBvj5ZrnBG/XXiFXUnryRwybdQWEPsdfs3rUEGtGJuyPKfmHebhCl1SZUh3EHrPoKxD2MKQCbgjXkDBjWJ5uqQ=
Message-ID: <58cb370e0701301811m101a191aif0968211e0f9c653@mail.gmail.com>
Date: Wed, 31 Jan 2007 03:11:18 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Free Linux Driver Development!
Cc: "Adrian Bunk" <bunk@stusta.de>, "Roland Dreier" <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070131012428.GA31759@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	 <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de>
	 <20070131012428.GA31759@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/07, Greg KH <greg@kroah.com> wrote:
> On Wed, Jan 31, 2007 at 02:13:40AM +0100, Adrian Bunk wrote:
> > On Tue, Jan 30, 2007 at 11:10:20AM -0800, Greg KH wrote:
> > > On Tue, Jan 30, 2007 at 09:45:50AM -0800, Roland Dreier wrote:
> > >...
> > > > And there are plenty of documented devices that no one cares enough
> > > > about to submit a driver for.
> > >
> > > Any specific examples?  I have a long list of people who wish to write
> > > new drivers but just don't know which hardware is not yet supported.
> > >...
> >
> > Wrinting a driver for shiny new hardware is cool.
> >
> > But understanding and maintaining an already existing driver and working
> > on bug reports for this driver is something not-so-cool that would be
> > required in many areas of the kernel.
> >
> > Would someone from your long list of people e.g. be willing to maintain
> > drivers/block/floppy.c ?
>
> What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
> that floppy.c is?  Do you want everyone just to run screaming from
> kernel development never to be seen again?
>
> :)
>
> Seriously, if you need help with something like this, bring it up on the
> kernel-janitors list, there are lots of people there that are willing to
> help out with stuff like long-term maintenance and bug fixing but don't
> know where to start.

http://bugzilla.kernel.org

:)

Bart
