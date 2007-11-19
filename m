Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbXKSMOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbXKSMOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXKSMOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:14:33 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53938 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXKSMOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:14:32 -0500
Date: Mon, 19 Nov 2007 17:57:13 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: [PATCH 0/2] sched: Group scheduler related patches
Message-ID: <20071119122713.GA28777@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	Here are two patches related to group cpu scheduling.

Patch 1/2 -> Fixes minor bugs and coding style issues
Patch 2/2 -> Improves group fairness on SMP systems.

This is probably one of the last big changes related to group scheduler
that I had on my plate. Pls apply if there is no objection from anyone.

-- 
Regards,
vatsa
