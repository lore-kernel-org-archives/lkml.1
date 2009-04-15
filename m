Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZDOQ0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZDOQ0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZDOQ0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:26:22 -0400
Received: from kroah.org ([198.145.64.141]:38034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972AbZDOQ0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:26:22 -0400
Date: Wed, 15 Apr 2009 09:03:12 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Galbraith <efault@gmx.de>, alan-jenkins@tuffmail.co.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30.git: USB storage (usbstick) automount woes - bisected
Message-ID: <20090415160311.GA20483@kroah.com>
References: <1239776669.6120.1.camel@marge.simson.net> <Pine.LNX.4.44L0.0904151137120.3072-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904151137120.3072-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 11:39:41AM -0400, Alan Stern wrote:
> On Wed, 15 Apr 2009, Mike Galbraith wrote:
> 
> > On Thu, 2009-04-09 at 10:53 +0100, Alan Jenkins wrote:
> > > On 4/9/09, Mike Galbraith <efault@gmx.de> wrote:
> > > > Greetings,
> > > >
> > > > Plugging a USB stick after the first big .30 pull (8e0ee43..c31f403) no
> > > > longer detects/automounts on my opensuse 11.0 x86_64 box.  Bisection
> > > > fingered e6e244b6cb1f70e7109381626293cd40a8334ed3.
> > > 
> > > Alan Stern posted a test patch here:
> > > <http://lkml.org/lkml/2009/4/8/735>.  I can confirm that this fixes
> > > the problem.
> > 
> > Ping.
> > 
> > (patchlet missed the boat for rc2)
> 
> The patch has been submitted, but Greg KH hasn't accepted it yet.

Sorry, -rc2 came out faster than I expected, I thought I had a few more
days :)

It will be in the next round of stuff to Linus.

thanks,

greg k-h
