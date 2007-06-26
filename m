Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbXFZPL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbXFZPL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbXFZPLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:11:34 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:46981 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbXFZPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:11:31 -0400
Date: Tue, 26 Jun 2007 11:11:25 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Message-ID: <20070626151125.GD8274@rhun.ibm.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org> <200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com> <46812ADF.3060609@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46812ADF.3060609@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 08:03:59AM -0700, Arjan van de Ven wrote:
> Muli Ben-Yehuda wrote:
> >How much? we have numbers (to be presented at OLS later this week)
> >that show that on bare-metal an IOMMU can cost as much as 15%-30% more
> >CPU utilization for an IO intensive workload (netperf). It will be
> >interesting to see comparable numbers for VT-d.
> 
> for VT-d it is a LOT less. I'll let anil give you his data :)

Looking forward to it. Note that this is on a large SMP machine with
Gigabit ethernet, with netperf TCP stream. Comparing numbers for other
benchmarks on other machines is ... less than useful, but the numbers
themeselves are interesting.

Cheers,
Muli

