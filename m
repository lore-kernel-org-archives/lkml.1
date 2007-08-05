Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbXHEFx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbXHEFx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 01:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXHEFxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 01:53:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbXHEFxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 01:53:20 -0400
Date: Sat, 4 Aug 2007 22:52:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Chuck Ebbert" <cebbert@redhat.com>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: Oops in 2.6.23-rc1-git9,
 arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-Id: <20070804225222.67fd9448.akpm@linux-foundation.org>
In-Reply-To: <86802c440708041202s4d165e6co701fe1c1e5c1a5ca@mail.gmail.com>
References: <46B3A7BB.9000102@redhat.com>
	<20070803155035.1fb11c9a.akpm@linux-foundation.org>
	<200708041130.42038.ak@suse.de>
	<20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	<86802c440708041045gd4a70fejf54f8532ff1a46f6@mail.gmail.com>
	<20070804111532.1d3936fa.akpm@linux-foundation.org>
	<86802c440708041202s4d165e6co701fe1c1e5c1a5ca@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007 12:02:35 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On 8/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sat, 4 Aug 2007 10:45:31 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >
> > > Andrew,
> > >
> > > still need
> x86_64-get-mp_bus_to_node-as-early-v2.patch is already in the -mm
> 
> it fixs
> pirq_peer_trick(void) in irq.c
> pcibios_fixup_peer_bridges in legacy.c
> 
> by allocate sd.
> 

I don't understand you much, sorry.  Are you saying that
x86_64-get-mp_bus_to_node-as-early-v2.patch should be merged in 2.6.23?

