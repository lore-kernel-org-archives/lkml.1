Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab0BXTdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:33:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:55716 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770Ab0BXTdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:33:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,534,1262592000"; 
   d="scan'208";a="495321798"
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
In-Reply-To: <1267033418.16023.326.camel@laptop>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
	 <1266588316.1529.370.camel@laptop>
	 <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
	 <1266608875.1529.749.camel@laptop>
	 <1266609029.4729.1.camel@sbs-t61.sc.intel.com>
	 <1266609734.1529.772.camel@laptop>
	 <1266628424.4729.23.camel@sbs-t61.sc.intel.com>
	 <1266864618.6122.472.camel@laptop>
	 <1266970432.11588.22.camel@sbs-t61.sc.intel.com>
	 <1267033418.16023.326.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 24 Feb 2010 11:31:12 -0800
Message-Id: <1267039872.5149.0.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 09:43 -0800, Peter Zijlstra wrote:
> On Tue, 2010-02-23 at 16:13 -0800, Suresh Siddha wrote:
> > 
> > Ok. Here is the patch with complete changelog. I added "Cc stable" tag
> > so that it can be picked up for 2.6.32 and 2.6.33, as we would like to
> > see this regression addressed in those kernels. Peter/Ingo: Can you
> > please queue this patch for -tip for 2.6.34?
> > 
> 
> Have picked it up with the following changes, Thanks!

Looks good. Thanks.

