Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYIHN0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYIHN0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYIHN0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:26:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:37491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbYIHN0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:26:15 -0400
Subject: Re: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
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
       Max Krasnyansky <maxk@qualcomm.com>
In-Reply-To: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 15:25:46 +0200
Message-Id: <1220880346.12278.17.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May I again ask to first clean up the current power saving code before
stacking more on top of it?

