Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYKWCJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYKWCJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 21:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbYKWCJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 21:09:30 -0500
Received: from viefep20-int.chello.at ([62.179.121.40]:39083 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbYKWCJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 21:09:29 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [RFC PATCH v4 0/7] Tunable sched_mc_power_savings=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
In-Reply-To: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
References: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 03:09:25 +0100
Message-Id: <1227406165.7685.20008.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 14:00 +0530, Vaidyanathan Srinivasan wrote:

> * Reverted sched MC level and CPU level fine tuning in v2.6.28-rc4 for
>   now.  These affect consolidation since SD_BALANCE_NEWIDLE is
>   removed.  I will rework the tuning in the next iteration to
>   selectively enable them at sched_mc=2

Looking forward to the next version.

