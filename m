Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZLXKJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZLXKJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 05:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZLXKJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 05:09:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:46920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753807AbZLXKJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 05:09:21 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+1MQhsOt+1IRsubnJo13Ku82WYJUwYYkn10cOdRM
	/TgvhLO65e/hy3
Subject: Re: [PATCH 7/6][RFC] sched: unify load_balance{,_newidle}()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       SureshSiddha <suresh.b.siddha@intel.com>,
       "Pallipadi,Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <1261646964.4937.172.camel@laptop>
References: <20091217185021.684424629@chello.nl>
	 <1261581216.4937.150.camel@laptop>
	 <1261629824.10947.13.camel@marge.simson.net>
	 <1261646964.4937.172.camel@laptop>
Content-Type: text/plain
Date: Thu, 24 Dec 2009 11:09:11 +0100
Message-Id: <1261649351.12219.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 10:29 +0100, Peter Zijlstra wrote:

> Is that with just this patch applied or also with the next one? I
> worried more about the next one.

The next one is the troublemaker.

	-Mike

