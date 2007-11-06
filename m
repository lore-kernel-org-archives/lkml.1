Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXKFDXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXKFDXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 22:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbXKFDXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 22:23:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbXKFDXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 22:23:00 -0500
Date: Mon, 5 Nov 2007 19:21:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Griffith <dgriffi@cs.csubak.edu>
Cc: Vitaliy Ivanov <vitalivanov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Clemens Ladisch <clemens@ladisch.de>,
       linux-usb-devel@lists.sourceforge.net, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: fixing usb-midi device support
Message-Id: <20071105192153.2bbae10f.akpm@linux-foundation.org>
In-Reply-To: <Pine.GSO.4.55.0711011018360.13024@helios.cs.csubak.edu>
References: <Pine.GSO.4.55.0710311423530.10148@helios.cs.csubak.edu>
	<35fbaa3e0711010346y5963d929w5054fabad1569d66@mail.gmail.com>
	<Pine.GSO.4.55.0711011018360.13024@helios.cs.csubak.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 10:20:24 -0700 (PDT) David Griffith <dgriffi@cs.csubak.edu> wrote:

> On Thu, 1 Nov 2007, Vitaliy Ivanov wrote:

Lots of cc's added.

> > David,
> >
> > On 10/31/07, David Griffith <dgriffi@cs.csubak.edu> wrote:
> > >
> > > I have a MOTU Fastlane and an Emu Xmidi 2x2 USB midi interfaces.  The Emu
> > > unit works fine with current kernels.  The MOTU unit won't work with
> > > kernels newer than 2.6.17.

It's a regression.

>  I stumbled over a patch that had something to
> > > do with a MOTU Fastlane, but I haven't been able to find it again.  Could
> > > I get some advice on fixing MOTU Fastlane support?
> >
> > I can see that you already had a discussion on this issue:
> > http://lkml.org/lkml/2007/8/10/102
> >
> > Any results? Do you still can see the oops?
> 
> The oops is still present.  I was hoping that the patch I found and lost
> would help me understand what was going on.
> 

Are you able to send a copy of the oops output?
