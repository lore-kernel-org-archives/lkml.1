Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYCJVAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYCJVAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYCJVAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:00:10 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:47419 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYCJVAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:00:09 -0400
Date: Mon, 10 Mar 2008 21:57:55 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: inotify fixes in stable
Message-ID: <20080310215755.7e920738@mjolnir.drzeus.cx>
In-Reply-To: <20080310203116.GC5943@kroah.com>
References: <20080310091155.02b7fe0e@mjolnir.drzeus.cx>
	<20080310160317.GB20775@kroah.com>
	<20080310203658.3bdbc27c@mjolnir.drzeus.cx>
	<20080310203116.GC5943@kroah.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 13:31:16 -0700
Greg KH <greg@kroah.com> wrote:

> On Mon, Mar 10, 2008 at 08:36:58PM +0100, Pierre Ossman wrote:
> > 
> > The system is an OpenSuse 10.3 system, so 2.6.22.y would be the
> > interesting one. I'll see if I can get a custom kernel in there (I've
> > been unable to reproduce the problem outside a production
> > environment).
> 
> 2.6.22.y is no longer being released by me, so it isn't interesting to
> me at all :)
> 

Oh? You made a release just 13 days ago, so I figured you were still giving it some love.

> What about 2.6.24?  Is this still an issue there?

Judging from the kernel bugzilla, it would seem so.

But in my specific case, the guy on site was going to try an updated kernel from Suse's build system. I'll probably now the results tomorrow or the day after that.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
