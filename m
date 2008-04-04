Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYDDQWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYDDQWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbYDDQWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:22:34 -0400
Received: from smtp25.orange.fr ([193.252.22.21]:10510 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbYDDQWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:22:33 -0400
X-ME-UUID: 20080404154446796.C257570000A8@mwinf2503.orange.fr
Subject: Re: ASUS ScreenDuo
From: Xavier Bestel <xavier.bestel@free.fr>
To: Bob Copeland <me@bobcopeland.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <b6c5339f0804040822u12fb0aaclb8991fb2f6c11dbd@mail.gmail.com>
References: <Pine.LNX.4.44L0.0804031506300.7376-100000@iolanthe.rowland.org>
	 <1207251545.24007.3.camel@bip.parateam.prv>
	 <b6c5339f0804031358q46379223ud4839c0de01290cf@mail.gmail.com>
	 <20080403212427.GE24239@csclub.uwaterloo.ca>
	 <b6c5339f0804040737k38839c71l19972e73325a48c4@mail.gmail.com>
	 <1207320911.3438.19.camel@skunk.anacadf.mentorg.com>
	 <b6c5339f0804040822u12fb0aaclb8991fb2f6c11dbd@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 17:43:54 +0200
Message-Id: <1207323834.9906.2.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On ven, 2008-04-04 at 11:22 -0400, Bob Copeland wrote:
> On Fri, Apr 4, 2008 at 10:55 AM, Xavier Bestel <xavier.bestel@free.fr> wrote:
> >  > If it is supposed to implement the MS SideShow API, then that would be
> >  > the .NET VM (i.e. C#).  My 10 second googling turned up some info about
> >  > that but I couldn't find a definition of how the hardware interface
> >  > for such devices is supposed to work.  There's some XML-laden software
> >  > API but it seemed to be transport agnostic.
> >
> >  Wouldn't there be at least 2 interfaces to the device ?
> 
> Who knows, they could have a almost-mass-storage protocol layer that
> recognizes proprietary stuff in the URBs.  It could be as simple as:
> 
>  - User clicks 'synchronize' in some windows app
>  - Device driver on host does some magic to make Asus device pretend like
>    removable media was inserted
>  - Vista sees the new device, mounts it
>  - App copies C# classes and XML files to special directories on the device
>  - App ejects device

Fair enough.

> Does the screen turn on or is that software controlled too?

There's a power-on button, which lits the screen and makes the device
connect to the usb host.

> This is pure wild guessing since I have no clue about SideShow or this
> device.  Anyway it would be hard to proceed without capturing a trace
> or managing to find some docs somewhere.

I certainly have no intention of installing vista on this host. I'll see
if I manage to borrow a windows laptop somewhere.

Thanks,
	Xav


