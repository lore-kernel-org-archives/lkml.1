Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbXIYFWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbXIYFWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 01:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbXIYFWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 01:22:08 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:55769 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbXIYFWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 01:22:07 -0400
Date: Tue, 25 Sep 2007 07:23:45 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: add missing header
Message-ID: <20070925072345.048086ae@poseidon.drzeus.cx>
In-Reply-To: <1190675352.19359.122.camel@localhost.localdomain>
References: <20070923081408.312e02c3@poseidon.drzeus.cx>
	<1190675352.19359.122.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 00:09:12 +0100
Richard Purdie <rpurdie@rpsys.net> wrote:

> On Sun, 2007-09-23 at 08:14 +0200, Pierre Ossman wrote:
> > rwlocks are used in the structures so make sure the right header
> > is included.
> > 
> > Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> 
> I think something similar was already committed in revision
> df96efd73b81b8bc2d23b3d8b6025cce3d43db6c.
> 

Indeed. I guess sometimes the solution to your problems is just a pull
away. ;)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
