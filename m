Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbZELKGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbZELKGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760391AbZELKGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:06:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49811 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760352AbZELKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:06:10 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter batch values for stats counters
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <1242122579.11251.325.camel@twins>
References: <20090512185836.D635.A69D9226@jp.fujitsu.com> <1242122579.11251.325.camel@twins>
Message-Id: <20090512190346.D638.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 May 2009 19:06:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-05-12 at 19:01 +0900, KOSAKI Motohiro wrote:
> > +#ifdef CONFIGCONFIG_SMP
> 
> typo ?

yes, this week is my memorial stupid one ;)



