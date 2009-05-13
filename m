Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbZEMNPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbZEMNPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZEMNPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:15:05 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:14724 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbZEMNPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:15:04 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation
 sched_max_capacity_pct=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
In-Reply-To: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
Content-Type: text/plain
Date: Wed, 13 May 2009 15:14:57 +0200
Message-Id: <1242220497.26820.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 18:41 +0530, Vaidyanathan Srinivasan wrote:

> * Peter Zijlstra wanted more justifications for throttling at the core
>   level.  Throttling may be a resource management problem rather than
>   scheduler/load balancer

No, I mandate that it be thermal management. Any other reason and you've
got a NAK.



