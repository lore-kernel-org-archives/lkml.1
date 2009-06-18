Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbZFRSPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbZFRSPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZFRSPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:15:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36229 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbZFRSPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:15:20 -0400
Date: Thu, 18 Jun 2009 11:13:37 -0700
From: Chris Wright <chrisw@redhat.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, David Woodhouse <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "'Allen Kay'" <allen.m.kay@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Message-ID: <20090618181337.GA2500@x200.localdomain>
References: <20090327212241.234500000@intel.com> <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090513231351.GA22386@linux-os.sc.intel.com> <1242314271.3393.11.camel@macbook.infradead.org> <20090514175944.GA5168@linux-os.sc.intel.com> <20090618180514.GA24082@linux-os.sc.intel.com> <20090618180835.GB6838@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618180835.GB6838@il.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Muli Ben-Yehuda (muli@il.ibm.com) wrote:
> On Thu, Jun 18, 2009 at 11:05:14AM -0700, Fenghua Yu wrote:
> 
> > IOMMU Identity Mapping Support: iommu_identity_mapping definition
> > 
> > Identity mapping for IOMMU defines a single domain to 1:1 map all
> > pci devices to all usable memory.
> 
> Why use VT-d at all in this case? Do you have a use-case in mind?

Device assignment.
