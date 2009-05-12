Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbZELKDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbZELKDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZELKDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:03:05 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:44157 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZELKDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:03:04 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
 batch values for stats counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090512185836.D635.A69D9226@jp.fujitsu.com>
References: <tip-50fbed3bb72cbe38a665512771a91a96d028de46@git.kernel.org>
	 <20090511150709.GA23787@elte.hu>
	 <20090512185836.D635.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 12:02:59 +0200
Message-Id: <1242122579.11251.325.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 19:01 +0900, KOSAKI Motohiro wrote:
> +#ifdef CONFIGCONFIG_SMP

typo ?

