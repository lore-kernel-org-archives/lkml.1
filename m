Return-Path: <linux-kernel-owner+w=401wt.eu-S934048AbXGWTJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbXGWTJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762732AbXGWTJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:09:01 -0400
Received: from relais.videotron.ca ([24.201.245.36]:36559 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762638AbXGWTJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:09:00 -0400
Date: Mon, 23 Jul 2007 15:08:59 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: Git tree for old kernels from before the current tree
In-reply-to: <20070723185732.GB30165@thunk.org>
X-X-Sender: nico@xanadu.home
To: Theodore Tso <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Paul Mundt <lethal@linux-sh.org>, Jon Smirl <jonsmirl@gmail.com>,
       Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.0.999.0707231507040.6355@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
 <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr>
 <20070722211314.GA13850@linux-sh.org>
 <Pine.LNX.4.64.0707222344540.32367@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707230000170.32367@fbirervta.pbzchgretzou.qr>
 <46A3D5EA.2050600@zytor.com>
 <alpine.LFD.0.999.0707230950340.3607@woody.linux-foundation.org>
 <20070723185732.GB30165@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Theodore Tso wrote:

> On Mon, Jul 23, 2007 at 09:55:24AM -0700, Linus Torvalds wrote:
> > 
> > I actually tried to get something like this together back in the BK days 
> > and early in the SCO saga. It was pretty painful to try to find all the 
> > historic trees and patches - they're all in different format, and some of 
> > them are unreliable (ie CVS imports by people like Ted).
> 
> Um, *I* never had the bad taste to import Linux kernels into CVS.  :-)
> 
> I'm pretty sure we never had anything like that on tsx-11.mit.edu, either.

Well, I remember having to clean up some of the source archives I've 
found which contained CVS directories.  Can't tell which one anymore, 
but they were amongst the oldest ones.


Nicolas
