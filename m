Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZDOPjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZDOPjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZDOPjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:39:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33946 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750966AbZDOPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:39:42 -0400
Date: Wed, 15 Apr 2009 11:39:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mike Galbraith <efault@gmx.de>, Greg KH <greg@kroah.com>
cc: alan-jenkins@tuffmail.co.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30.git: USB storage (usbstick) automount woes - bisected
In-Reply-To: <1239776669.6120.1.camel@marge.simson.net>
Message-ID: <Pine.LNX.4.44L0.0904151137120.3072-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009, Mike Galbraith wrote:

> On Thu, 2009-04-09 at 10:53 +0100, Alan Jenkins wrote:
> > On 4/9/09, Mike Galbraith <efault@gmx.de> wrote:
> > > Greetings,
> > >
> > > Plugging a USB stick after the first big .30 pull (8e0ee43..c31f403) no
> > > longer detects/automounts on my opensuse 11.0 x86_64 box.  Bisection
> > > fingered e6e244b6cb1f70e7109381626293cd40a8334ed3.
> > 
> > Alan Stern posted a test patch here:
> > <http://lkml.org/lkml/2009/4/8/735>.  I can confirm that this fixes
> > the problem.
> 
> Ping.
> 
> (patchlet missed the boat for rc2)

The patch has been submitted, but Greg KH hasn't accepted it yet.

Alan Stern

