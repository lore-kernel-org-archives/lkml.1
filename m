Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbXKTM2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbXKTM2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbXKTM2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:28:46 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49493 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbXKTM2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:28:45 -0500
Date: Tue, 20 Nov 2007 18:11:19 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
Message-ID: <20071120124119.GA2154@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119151756.GA25446@elte.hu> <20071120112459.GA2884@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120112459.GA2884@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 12:24:59PM +0100, Damien Wyart wrote:
> Testing sched-cfs-v2.6.24-rc3-v24.patch on top of 2.6.24-rc3-git1
> (ignored the two "already applied" messages coming from git1 commits),
> I get a 1.00 minimum load in top, coming from the load_balance_mo thread
> staying in D-state. I get this on 2 different computers with similar
> configs, so I am attaching one of them here.

Ingo,
	I am reworking the fair-group load balance patches. Can you drop
what you have until I resubmit?

-- 
Regards,
vatsa
