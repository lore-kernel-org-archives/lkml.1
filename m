Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbXFZQAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbXFZQAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXFZQAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:00:43 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:21300 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXFZQAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:00:42 -0400
Date: Tue, 26 Jun 2007 12:00:32 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, suresh.b.siddha@intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Message-ID: <20070626160032.GF8274@rhun.ibm.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org> <200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com> <46812ADF.3060609@linux.intel.com> <20070626151125.GD8274@rhun.ibm.com> <20070626154803.GA3374@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626154803.GA3374@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 08:48:04AM -0700, Keshavamurthy, Anil S wrote:

> Our initial benchmark results showed we had around 3% extra CPU
> utilization overhead when compared to native(i.e without IOMMU).
> Again, our benchmark was on small SMP machine and we used iperf and
> a 1G ethernet cards.

Please try netperf and a bigger machine for a meaningful comparison :-)
I assume this is with e1000?

> Going forward we will do more benchmark tests and will share the
> results.

Looking forward to it.

Cheers,
Muli
