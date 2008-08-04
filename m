Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbYHDHM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbYHDHM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYHDHMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:12:21 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:42170 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbYHDHMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:12:20 -0400
X-SourceIP: 80.57.229.25
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20080804070508.GA4028@linux.vnet.ibm.com>
References: <1217489463.25608.157.camel@ymzhang>
	 <1217489949.8157.78.camel@twins> <1217490560.25608.168.camel@ymzhang>
	 <1217551154.25608.169.camel@ymzhang>
	 <20080801051407.GA5232@linux.vnet.ibm.com>
	 <1217826278.25608.198.camel@ymzhang>
	 <20080804052228.GA5444@linux.vnet.ibm.com>
	 <1217828278.25608.206.camel@ymzhang>
	 <20080804055339.GB5444@linux.vnet.ibm.com> <1217831171.9016.42.camel@twins>
	 <20080804070508.GA4028@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 09:12:19 +0200
Message-Id: <1217833939.9016.47.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 12:35 +0530, Dhaval Giani wrote:
> On Mon, Aug 04, 2008 at 08:26:11AM +0200, Peter Zijlstra wrote:
> > On Mon, 2008-08-04 at 11:23 +0530, Dhaval Giani wrote:
> > 
> > > Peter, vatsa, any ideas?
> > 
> > ---
> > 
> > Revert:
> >   a7be37ac8e1565e00880531f4e2aff421a21c803  sched: revert the revert of: weight calculations
> >   c9c294a630e28eec5f2865f028ecfc58d45c0a5a  sched: fix calc_delta_asym()
> >   ced8aa16e1db55c33c507174c1b1f9e107445865  sched: fix calc_delta_asym, #2
> > 
> 
> Did we not fix those? :) 

Works for me,.. just guessing here.

