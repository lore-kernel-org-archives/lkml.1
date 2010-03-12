Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0CLI0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:26:25 -0500
Received: from poutre.nerim.net ([62.4.16.124]:52546 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab0CLI0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:26:23 -0500
Date: Fri, 12 Mar 2010 09:26:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, monstr@monstr.eu,
       gregkh@suse.de, benh@kernel.crashing.org, akpm@linux-foundation.org,
       davem@davemloft.net, sfr@canb.auug.org.au, jgarzik@pobox.com,
       ben-linux@fluff.org, dwmw2@infradead.org, jeremy.kerr@canonical.com,
       James.Bottomley@suse.de, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org, timur@freescale.com, lrg@slimlogic.co.uk
Subject: Re: [PATCH 33/37] sound/soc: use .dev.of_node instead of .node in 
  struct of_device
Message-ID: <20100312092619.6a6f5e20@hyperion.delvare>
In-Reply-To: <fa686aa41003111322wc1f15b2hd3f653af060f56bf@mail.gmail.com>
References: <20100311174830.4824.19820.stgit@angua>
	<20100311180649.4824.10368.stgit@angua>
	<20100311193458.GA13289@opensource.wolfsonmicro.com>
	<fa686aa41003111322wc1f15b2hd3f653af060f56bf@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 14:22:37 -0700, Grant Likely wrote:
> On Thu, Mar 11, 2010 at 12:34 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Thu, Mar 11, 2010 at 11:06:50AM -0700, Grant Likely wrote:
> >> .node is being removed
> >>
> >> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >
> > but please ensure that Liam and especially Timur also check this (both
> > CCed).
> >
> > For enormous patch serieses like this it's really nice if you can ensure
> > that each person is only CCed on the patches that they need to review.
> > Much less stuff in the inbox.
> 
> Yeah, sorry about that (and to everyone receiving this thread, I'm
> really sorry.  I won't do it again).  I've already been yelled at for
> that.  What happened is that on a previous series I was yelled at for
> not sending all patches to everyone (so that the patches could be
> reviewed in context).  So, naturally, I made sure to include everyone
> on the whole series this time....  doh.
> 
> Next time I post I'll constrain it to small chunks.

A good compromise IMHO is to send only the pieces they really have to
see and ack to each person, and provide a pointer to somewhere the full
series can be seen and downloaded for the interested.

-- 
Jean Delvare
