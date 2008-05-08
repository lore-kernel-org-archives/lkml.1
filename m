Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbYEHFWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbYEHFWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 01:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYEHFWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 01:22:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:58837 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbYEHFWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 01:22:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,453,1204531200"; 
   d="scan'208";a="279101357"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080507174209.GB4424@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang>
	 <20080507174209.GB4424@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 13:21:27 +0800
Message-Id: <1210224087.3453.107.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 23:12 +0530, Dhaval Giani wrote:
> On Tue, May 06, 2008 at 10:06:30AM +0800, Zhang, Yanmin wrote:
> > Comparing with 2.6.25, volanoMark has big regression with kernel 2.6.26-rc1.
> > It's about 50% on my 8-core stoakley, 16-core tigerton, and Itanium Montecito.
> > 
> 
> Just FYI, I am actually seeing 5 times performance on 2.6.26-rc1
> (I ran the benchmark twice before i sent out this mail and both
> times I have have these numbers)
What's the hardware/software configuration? And kernel .config?

