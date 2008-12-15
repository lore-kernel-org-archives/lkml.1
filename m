Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYLOISb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYLOISb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYLOISX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:18:23 -0500
Received: from viefep19-int.chello.at ([62.179.121.39]:57142 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752012AbYLOISW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:18:22 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [RFC PATCH v5 0/7] Tunable sched_mc_power_savings=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
In-Reply-To: <20081214200843.GO5457@dirshya.in.ibm.com>
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com>
	 <19700101001343.GA1440@ucw.cz>  <20081214200843.GO5457@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 09:18:20 +0100
Message-Id: <1229329100.14605.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 01:38 +0530, Vaidyanathan Srinivasan wrote:

> I am open to suggestion on any interesting workload that should be
> tested.  I have tested ebizzy and SPECjbb for power savings.  

Try some of the typical fortran stuff like lapack?

