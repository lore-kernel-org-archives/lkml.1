Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbXAaG0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbXAaG0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 01:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbXAaG0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 01:26:24 -0500
Received: from mail.kroah.org ([69.55.234.183]:55747 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915AbXAaG0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 01:26:24 -0500
Date: Tue, 30 Jan 2007 22:26:07 -0800
From: Greg KH <greg@kroah.com>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070131062607.GA14548@kroah.com>
References: <20070130012904.GA9617@kroah.com> <f2b55d220701301827h703d24eele941c86046caa9e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220701301827h703d24eele941c86046caa9e7@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 06:27:29PM -0800, Michael K. Edwards wrote:
> On 1/29/07, Greg KH <greg@kroah.com> wrote:
> >Free Linux Driver Development!
> >
> >Yes, that's right, the Linux kernel community is offering all companies
> >free Linux driver development.  ...
> [snip]
> >[1] for the CPUs that support the bus types that your device works on.
> 
> Bravo!  Now, is there a message in the same spirit that can be
> tailored to embedded space, especially to SoC vendors and (even more
> importantly) their customers?  Something along the lines of:
> 
> "We understand that embedded hardware is frequently buggy and that SoC
> vendors are doing well if their own internal software people can get
> enough help from the chip guys to bring up enough customer-driven use
> cases to win a few design-ins.
> 
> We sympathize with embedded developers who stay up nights with an
> O-scope and a JTAG emulator reverse-engineering the hardware behavior,
> trying to figure out which this order of operations works and this
> other one doesn't.
> 
> We have the software tools and the competence to quantify the
> potential gains from current toolchains and kernels, aggressive
> compilation options, and in-tree power/latency management strategies,
> so that you can build a business case against "fire and forget" SDKs
> based on ancient compilers, obsolete kernels, and unmaintained
> out-of-tree patches.
> 
> We will help platform integrators bridge the gap between the chip
> architects' claims about device performance and the condition in which
> the BSP guys toss drivers over the fence.
> 
> You can hang onto the hardware and profit from coaching and code
> review, or you can send us a board and whatever doco you've got, and
> we'll figure it out.
> 
> All we ask is that 1) SoC vendors authorize customers to do an NDA
> with OSDL and pass vendor NDA material along to us; 2) when the
> product ships, all participants are free to exercise GPL rights with
> respect to the chip support and driver code produced; and 3) platform
> integrators cooperate with the rework usually needed as code merges
> towards Linus's tree."
> 
> Or is this a pipe dream?

Oh, I would love to see something like that happen :)

As I come from an embedded background, I love to see Linux running in
tiny systems.  So anything I can do to help out with that I'd love to
offer.

But being able to read the minds of SOC hardwre engineers and decode all
of the documentation errors they produce is enough to drive one crazy,
my condolences go out to everyone in that situation...

good luck,

greg k-h
