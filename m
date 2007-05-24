Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXEXRRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXEXRRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXEXRRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:17:04 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:58124 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXEXRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:17:03 -0400
Date: Thu, 24 May 2007 03:16:46 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, clameter@sgi.com,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       heiko.carstens@de.ibm.com
Subject: Re: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Message-ID: <20070524101646.GA3893@localhost.localdomain>
References: <20070523104946.f279241c.akpm@linux-foundation.org> <79E93560F4A5FD42BB769DAAF8BEF62A01AA8C77@scsmsx411.amr.corp.intel.com> <20070523185748.GA4072@localhost.localdomain> <1179997436.8070.3.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179997436.8070.3.camel@localhost>
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 11:03:56AM +0200, Martin Schwidefsky wrote:
> On Wed, 2007-05-23 at 11:57 -0700, Ravikiran G Thirumalai wrote:
> 
> Current git with the patches applied and the default configuration for
> s390 decreases the section size fof .data.percpu from 0x3e50 to 0x3e00.
> 0.5% decrease.
> 

Thanks!!
Fenghua, you could use my 'Acked by' if needed
Acked-by: Ravikiran Thirumalai <kiran@scalex86.org>
