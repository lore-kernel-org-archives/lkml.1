Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbYEWJd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbYEWJd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYEWJdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:33:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44562 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbYEWJdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:33:50 -0400
Date: Fri, 23 May 2008 15:12:16 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Chris Friesen" <cfriesen@nortel.com>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, <pj@sgi.com>
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080523094216.GK3780@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com> <1211439417.29104.7.camel@twins> <4835D14B.20904@nortel.com> <1211486868.6463.134.camel@lappy.programming.kicks-ass.net> <5FD5754DDBA0B1499B5A0B4BB54194850357ED61@fmsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB54194850357ED61@fmsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 01:18:33PM -0700, Li, Tong N wrote:
> Peter,
> 
> I didn't look at your patches, but I thought you were flattening group
> weights down to task-level so that the scheduler only looks at per-task
> weights.

Wouldnt that require task weight readjustment upon every fork/exit?

> That'd make group fairness as good as task fairness gets. Is
> this still the case?

-- 
Regards,
vatsa
