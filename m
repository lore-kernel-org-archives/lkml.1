Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYBYScS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYBYScS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYBYScI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:32:08 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:51883 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbYBYScH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:32:07 -0500
Date: Mon, 25 Feb 2008 19:31:34 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
Message-ID: <20080225193134.104b386d@mjolnir.drzeus.cx>
In-Reply-To: <Pine.LNX.4.44L0.0802251255000.5039-100000@iolanthe.rowland.org>
References: <20080225184102.0a2e2bb5@mjolnir.drzeus.cx>
	<Pine.LNX.4.44L0.0802251255000.5039-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 12:58:30 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Thanks for the explanations.
> 
> On Mon, 25 Feb 2008, Pierre Ossman wrote:
> 
> > Trying to keep up with the PM changes is a full time job. For now I've
> > mostly ignored it as I don't even have time for the other stuff.
> > Patches welcome.
> 
> What do you think of the patch attached to comment #40 in the Bugzilla 
> entry?
> 

Looks ok. As long as those two synchronization points are guaranteed,
then I'm happy.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
