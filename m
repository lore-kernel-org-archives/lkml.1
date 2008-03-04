Return-Path: <linux-kernel-owner+w=401wt.eu-S1763082AbYCDL3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763082AbYCDL3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYCDL3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:29:11 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:46011 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYCDL3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:29:10 -0500
Date: Tue, 4 Mar 2008 16:57:41 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, yanmin_zhang@linux.intel.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-ID: <20080304112741.GA13428@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <200803030316.07165.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803030316.07165.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
> Subject		: 2.6.25-rc1: volanoMark 45% regression
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-02-13 10:30
> References	: http://lkml.org/lkml/2008/2/13/128
> Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 		  Balbir Singh <balbir@linux.vnet.ibm.com>
 
Peter's revert of the load balance patches should fix this one. Yanmin,
could you please confirm if the patch at
http://lkml.org/lkml/2008/2/25/202 helps?

-- 
regards,
Dhaval
