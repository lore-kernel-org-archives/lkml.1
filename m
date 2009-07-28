Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZG1TXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZG1TXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZG1TXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:23:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57870 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743AbZG1TXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:23:16 -0400
Date: Tue, 28 Jul 2009 20:24:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the ttydev tree with the
 usb.current tree
Message-ID: <20090728202412.78444d4e@lxorguk.ukuu.org.uk>
In-Reply-To: <200907282121.33231.oliver@neukum.org>
References: <20090728140110.7cfe7c22.sfr@canb.auug.org.au>
	<20090728163222.GA14899@kroah.com>
	<20090728163420.GB14899@kroah.com>
	<200907282121.33231.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 21:21:32 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> Am Dienstag, 28. Juli 2009 18:34:20 schrieb Greg KH:
> > > > Oliver: I'll send you an alternative patch later today/tomorrow that
> > > > uses the ASYNC flags.
> > >
> > > Should I just drop Oliver's existing patch from my tree for now then?
> >
> > Ok, in order to get a good merge for today, I've dropped it now.
> >
> > Oliver, care to work with Alan to get something that is agreeable to
> > everyone?
> 
> Sure. Alan, is there a driver you can recommend for looking at to learn how
> to correctly use the tty layer?

I'm no longer tty maintainer, please take it up with Linus.

Alan
