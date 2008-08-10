Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYHJGBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYHJGBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 02:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYHJGBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 02:01:42 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:38734 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752006AbYHJGBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 02:01:41 -0400
Date: Sun, 10 Aug 2008 11:31:22 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miao Xie <miaox@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [Bug #11207] VolanoMark regression with 2.6.27-rc1
Message-ID: <20080810060122.GB19796@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.xxC.VEjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX_-nNkxKaF.A.xxC.VEjnIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 

Yes, it should still be.

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
> Subject		: VolanoMark regression with 2.6.27-rc1
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-07-31 3:20 (10 days old)
> References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
> Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> 		  Peter Zijlstra <a.p.zijlstra@chello.nl>
> 		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 		  Miao Xie <miaox@cn.fujitsu.com>
> 

-- 
regards,
Dhaval
