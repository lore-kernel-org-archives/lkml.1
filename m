Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbYG2Kdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbYG2Kdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYG2Kdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:33:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47552
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbYG2Kdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:33:45 -0400
Date: Tue, 29 Jul 2008 03:33:42 -0700 (PDT)
Message-Id: <20080729.033342.21049184.davem@davemloft.net>
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com, sfr@canb.auug.org.au,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729103146.GA32407@elte.hu>
References: <20080729.031005.203132019.davem@davemloft.net>
	<20080729192834M.fujita.tomonori@lab.ntt.co.jp>
	<20080729103146.GA32407@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 29 Jul 2008 12:31:46 +0200

> i've queued up your quick fix in tip/x86/urgent to resolve the immediate 
> -git build breakage. The wider patch can then be done on top of that, 
> without being rushed. Any objections to this approach?

I do not object :-)
