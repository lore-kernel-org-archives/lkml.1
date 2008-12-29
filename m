Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYL2Uj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYL2Uj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYL2UhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:37:25 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55733 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbYL2UhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:37:23 -0500
Date: Mon, 29 Dec 2008 21:37:20 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/13] drivers/usb/gadget: use USB API functions rather
 than constants
In-Reply-To: <200812291222.48966.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0812292137120.2265@ask.diku.dk>
References: <Pine.LNX.4.44L0.0812291452580.1979-100000@iolanthe.rowland.org>
 <200812291222.48966.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, David Brownell wrote:

> On Monday 29 December 2008, Alan Stern wrote:
> > On Mon, 29 Dec 2008, David Brownell wrote:
> > 
> > > Those functions were supposed to go into <linux/usb/ch9.h>, as
> > > I recall, since they weren't specific to the host side stack.
> > > 
> > > Having them added to the wrong file is surely part of why
> > > they've only been used by host side drivers.  :)
> > 
> > Would you like to write a patch moving the functions to ch9.h?  Or 
> > would you like to ask Julia or me to do it?
> 
> Someone other than me.  ;)
> 
> Maybe someone on K-J will want to volunteer with a patch
> before either you or Julia...

I am working on it.

julia
