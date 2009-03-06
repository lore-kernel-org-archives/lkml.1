Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZCFXIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZCFXIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZCFXIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:08:11 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:51476 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCFXIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:08:10 -0500
Date: Fri, 6 Mar 2009 23:08:04 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: Re: Dynamically determine if kernel includes CFS Scheduler
Message-ID: <20090306230804.GA963@silver.sucs.org>
References: <49B18B2E.606@us.ibm.com> <20090306225312.GA25593@silver.sucs.org> <49B1AB3A.2050303@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B1AB3A.2050303@us.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 03:01:14PM -0800, Darren Hart wrote:
>
> So I am of course in agreement with both you and Peter.  In this case, 
> the development team of an existing product is trying to move away from 
> heavy use of sched_yield(), and the CFS scheduler provides some 

Hmm. The only thing I'll say about checking kernel versions is: do some
tests/checks with the different enterprise distro kernels. I don't think
they tend to do big backports any more but if they have that kernel
version check could become tricky...

-- 
Sitsofe | http://sucs.org/~sits/
