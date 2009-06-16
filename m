Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZFPJTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZFPJTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZFPJTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:19:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:4284 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861AbZFPJTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:19:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,227,1243839600"; 
   d="scan'208";a="525100296"
Date: Tue, 16 Jun 2009 11:21:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] MFD: Added Timberdale driver
Message-ID: <20090616092144.GB4305@sortiz.org>
References: <4A292099.2020306@mocean-labs.com> <20090615101116.GB4094@sortiz.org> <20090615085654.d8504527.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615085654.d8504527.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 08:56:54AM -0700, Andrew Morton wrote:
> On Mon, 15 Jun 2009 12:11:19 +0200 Samuel Ortiz <sameo@linux.intel.com> wrote:
> 
> > On Fri, Jun 05, 2009 at 03:41:45PM +0200, Richard R__jfors wrote:
> > > MFD driver for the Timberdale FPGA The FPGA can be found on the
> > > Intel Atom development board, Russellville for in-vechicle infotainment
> > > 
> > > The FPGA is connected via PCIe
> > > 
> > > The driver basically exposes a lot of platform devices for the
> > > different IPs within the FPGA, and doing IRQ multiplexing
> > > 
> > > Signed-off-by: Richard R__jfors <richard.rojfors.ext@mocean-labs.com>
> > patch #4 of this serie is an mfd driver too, so I guess I should have been
> > cc'ed on it too.
> > So, if I understand this thread correctly, we should proceed like that:
> > 
> > 1) Richard comes up with an updated xilinx patch (patch #2).
> > 2) Andrew sends all patches but patch 7 to the relevant maintainers.
> > 3) When all patches but 7 are in Linus tree, I take patch 7 and include it in
> > my pull request to Linus.
> > 
> > Andrew, does that make sense to you? Do you want me to take patch #4 as well?
> 
> We could do it that way.  Or maintainers could just review-and-ack the
> relevant patches and I could merge them.
If the latter is more convenient to you, then feel free to add my
Acked-by: Samuel Ortiz <sameo@linux.intel.com> to patch #7.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
