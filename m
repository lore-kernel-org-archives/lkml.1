Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXC0Qdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXC0Qdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933092AbXC0Qdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:33:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60916 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036AbXC0Qdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:33:35 -0400
Date: Tue, 27 Mar 2007 08:33:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>, Parag Warudkar <parag.warudkar@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       Ben Dooks <ben-linux@fluff.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Linux 2.6.21-rc5
Message-Id: <20070327083310.92d3d2be.akpm@linux-foundation.org>
In-Reply-To: <200703271425.07762.ak@suse.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	<20070326221731.f4792260.akpm@linux-foundation.org>
	<200703271425.07762.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 14:25:07 +0200 Andi Kleen <ak@suse.de> wrote:

> On Tuesday 27 March 2007 08:17, Andrew Morton wrote:
> > 
> > I have a few fixes here which belong to subsystem trees, which were missed
> > by the maintainers and which we probably want to get into 2.6.21.
> > 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/make-aout-executables-work-again.patch
> 
> This is already fixed in a different way.
> 

oh yeah.  Did that fix make it into 2.6.20.x?

I think we decided that make-aout-executables-work-again.patch might still
be a desirable thing to have, but I don't recall the reasoning for that.

Anyway, if it doesn't fix a bug it is nowhere near a high-priority patch
for that seething bugfest which we like to call a kernel, so I'll drop it.
