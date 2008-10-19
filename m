Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbYJSVWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbYJSVWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 17:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYJSVWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 17:22:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:36101 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYJSVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 17:22:39 -0400
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joro@8bytes.org>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       fenghua.yu@intel.com, tony.luck@intel.com, suresh.b.siddha@intel.com,
       sfr@canb.auug.org.au, andreas.herrmann3@amd.com,
       joseph.cihula@intel.com, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
In-Reply-To: <1224438164.6770.1493.camel@macbook.infradead.org>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
	 <20081019111203.GB29705@8bytes.org>
	 <1224415198.6770.1464.camel@macbook.infradead.org>
	 <20081019124732.GA21115@elte.hu>
	 <1224422474.6770.1475.camel@macbook.infradead.org>
	 <20081019172651.GA19265@elte.hu>
	 <1224438164.6770.1493.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Sun, 19 Oct 2008 23:21:44 +0200
Message-Id: <1224451305.8861.9.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 18:42 +0100, David Woodhouse wrote:

> > it's tip/auto-iommu-next.
> 
> I have no idea what that means.

git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
git remote update
git checkout tip/auto-iommu-next



