Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbZFJVF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbZFJVF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762109AbZFJVFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:05:34 -0400
Received: from fifo99.com ([67.223.236.141]:33607 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762102AbZFJVFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:05:33 -0400
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Daniel Walker <dwalker@fifo99.com>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
In-Reply-To: <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 14:05:34 -0700
Message-Id: <1244667934.5982.90.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 13:24 -0700, Brian Swetland wrote:
> On Wed, Jun 10, 2009 at 12:48 PM, Russell King - ARM
> Linux<linux@arm.linux.org.uk> wrote:
> > On Wed, Jun 10, 2009 at 12:31:31PM +0200, Pavel Machek wrote:
> >> Is there patch for Dream support for 2.6.30 somewhere? The best I
> >> could find is linux-msm tree, which is ... quite a big diff against
> >> 2.6.24:
> >
> > In short not as far as I know, and I'm very disappointed with the state
> > of affairs with google.
> >
> > Basically, the situation surrounding msm can be described as severely
> > wanting - bear in mind that it's been over a year since we last heard
> > anything from the msm guys as far as code submissions go.
> >
> > Personally, I think we should delete the entire codeset which was
> > submitted into mainline - it's next to useless and all the time that
> > folk sit on their hands not maintaining it, it's just not worth having
> > it anywhere near mainline.
> 
> I'd love to find an effective way to get more of the msm support
> cleaned up (as necessary) and into the mainline.  We're bringing our
> work forward and rebasing to keep tracking the latest released kernel,
> and working on getting core bits we need that other stuff depends on
> in -- look at the thread on linux-pm where the wakelock/suspendblocker
> framework has been reviewed, revised, resent repeatedly, etc.

I assume you guys would accept community submitted clean up patches
right? Is there someone maintaining the MSM changes, you maybe?

> The msm7k unfortunately requires a lot of infrastructure to work given
> that the baseband (a black box to us) controls much of the world.
> Last time around when I tried submitting some of the core ipc support
> to talk to it on the lakml, there seemed to be uncertainty about who
> even would review that.

Typically you send stuff to LKML (or other mailing list) for review,
it's not like only one person would be reviewing the code.

Daniel

