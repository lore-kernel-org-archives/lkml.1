Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbXGPSiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbXGPSiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXGPSiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:38:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:47706 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbXGPSiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:38:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,542,1175497200"; 
   d="scan'208";a="266916882"
Date: Mon, 16 Jul 2007 11:32:45 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: "Li, Tong N" <tong.n.li@intel.com>,
       Giuseppe Bilotta <giuseppe.bilotta@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Message-ID: <20070716183244.GC3318@linux-os.sc.intel.com>
References: <20070715234543.GN3565@stusta.de> <5FD5754DDBA0B1499B5A0B4BB54194850164B27C@fmsmsx411.amr.corp.intel.com> <20070716065610.GA3653@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716065610.GA3653@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 08:56:10AM +0200, Adrian Bunk wrote:
> On Sun, Jul 15, 2007 at 10:03:02PM -0700, Li, Tong N wrote:
> > 
> > There are various metrics a scheduler may want to optimize for, such as
> > throughput, response time, power consumption, fairness, and so on. Each
> > of these may also be defined differently in different environments. Take
> > fairness as an example. People have traditionally talked about it in
> > terms of CPU time. Now it'd also make sense to talk about scheduling
> > that enables fair usage of other types of resources, such as shared
> > caches. Different metrics may require different scheduling policies.
> 
> Are these real-life problems people need solutions for today or just 
> thoughts someone might want to try and write a paper about?

We are at the door step of multi core evolution. So its a bit of both.

thanks,
suresh
