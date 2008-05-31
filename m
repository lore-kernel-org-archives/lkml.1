Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbYEaTJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbYEaTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbYEaTDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 15:03:06 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:44147 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792AbYEaTDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 15:03:04 -0400
Date: Sun, 1 Jun 2008 00:32:48 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [Bug #10634] volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080531190247.GA4569@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.Z8F.ltZQIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <UJSav77TyUB.A.Z8F.ltZQIB@albercik>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 07:48:05PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10634
> Subject		: volanoMark regression with kernel 2.6.26-rc1
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-05-06 2:06 (26 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121003968414287&amp;w=2
> Handled-By	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 		  Ingo Molnar <mingo@elte.hu>
> 		  Peter Zijlstra <a.p.zijlstra@chello.nl>
> Patch		: http://marc.info/?l=linux-kernel&amp;m=121015292616788&amp;w=2
> 

Should have been fixed with 6363ca57c76b7b83639ca8c83fc285fa26a7880e

Yanmin, could you confirm please?
-- 
regards,
Dhaval
