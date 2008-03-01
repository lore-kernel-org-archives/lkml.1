Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbYCAOsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbYCAOsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYCAOsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:48:12 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:43376 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbYCAOsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:48:11 -0500
Date: Sat, 1 Mar 2008 15:47:11 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
Message-ID: <20080301154711.372dd28a@mjolnir.drzeus.cx>
In-Reply-To: <Pine.LNX.4.44L0.0803010931090.4212-100000@netrider.rowland.org>
References: <20080301151155.55209ebb@mjolnir.drzeus.cx>
	<Pine.LNX.4.44L0.0803010931090.4212-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008 09:36:36 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> 
> The easiest way to do this will be to wait until some planned updates 
> are added to the PM core; then this will be a quick and simple change.  
> That probably means waiting until after 2.6.25 is released, however.
> 

Ok. Just give me a poke when it's time.

--
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
