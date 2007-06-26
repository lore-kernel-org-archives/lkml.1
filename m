Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbXFZPQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbXFZPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbXFZPQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:16:51 -0400
Received: from mga05.intel.com ([192.55.52.89]:50545 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754138AbXFZPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:16:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="261316081"
Message-ID: <46812D79.8080306@linux.intel.com>
Date: Tue, 26 Jun 2007 08:15:05 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>	<20070625234550.058635cb.akpm@linux-foundation.org>	<200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com> <p73645a675q.fsf@bingen.suse.de>
In-Reply-To: <p73645a675q.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Also the user interface for X server case needs more work.
> 

actually with the mode setting of X moving into the kernel... X won't 
use /dev/mem anymore at all
(and I think it mostly already doesn't even without that)
