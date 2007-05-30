Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbXE3AyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbXE3AyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXE3AyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:54:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:38099 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbXE3AyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:54:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,590,1170662400"; 
   d="scan'208";a="250967787"
Date: Tue, 29 May 2007 17:50:52 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, colpatch@us.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>, Con Kolivas <kernel@kolivas.org>,
       Christoph Lameter <clameter@sgi.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070530005052.GE3693@linux-os.sc.intel.com>
References: <464DA61A.4040406@bigpond.net.au> <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com> <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au> <4652DC03.60801@bigpond.net.au> <4655423E.6000202@bigpond.net.au> <20070524164538.GA13301@linux-os.sc.intel.com> <46561E67.3030207@bigpond.net.au> <20070529204557.GB3693@linux-os.sc.intel.com> <465CBD35.2000109@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465CBD35.2000109@bigpond.net.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 04:54:29PM -0700, Peter Williams wrote:
> > I tried with various refresh rates of top too.. Do you see the issue
> > at runlevel 3 too?
> 
> I haven't tried that.
> 
> Do your spinners ever relinquish the CPU voluntarily?

Nope. Simple and plain while(1); 's

I can try 32-bit kernel to check.

thanks,
suresh
