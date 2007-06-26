Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbXFZQbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbXFZQbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbXFZQbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:31:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:33843 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbXFZQbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:31:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="261346391"
Date: Tue, 26 Jun 2007 09:26:38 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 10/10] Iommu floppy workaround
Message-ID: <20070626162637.GC3374@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213809.110034000@askeshav-devel.jf.intel.com> <20070625234222.a1e09a16.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625234222.a1e09a16.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 11:42:22PM -0700, Andrew Morton wrote:
> On Tue, 19 Jun 2007 14:37:11 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> Bit weird that this was implemented in the header like that.
Sorry, it is my mistake as I understood thus from your previous
code review comment.
> 
> How about this?  (Also contains rather a lot of obvious style fixes)
Yup, looks good.

-Anil
