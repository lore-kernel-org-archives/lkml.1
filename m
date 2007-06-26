Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbXFZPFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbXFZPFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbXFZPFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:05:46 -0400
Received: from mga07.intel.com ([143.182.124.22]:30770 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755957AbXFZPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:05:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,463,1175497200"; 
   d="scan'208";a="243520701"
Message-ID: <46812ADF.3060609@linux.intel.com>
Date: Tue, 26 Jun 2007 08:03:59 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org> <200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com>
In-Reply-To: <20070626111324.GB4320@rhun.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
> How much? we have numbers (to be presented at OLS later this week)
> that show that on bare-metal an IOMMU can cost as much as 15%-30% more
> CPU utilization for an IO intensive workload (netperf). It will be
> interesting to see comparable numbers for VT-d.

for VT-d it is a LOT less. I'll let anil give you his data :)
