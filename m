Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZAIGA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZAIGA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZAIGAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:00:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:53651 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751125AbZAIGAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:00:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+IjSMpEMWI7by201NDzhqJVdz4gt5Ic1E5FBw5AZ
	tLx3WDz9D1WCZJ
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: svaidy@linux.vnet.ibm.com
Cc: balbir@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090108174655.GQ4574@dirshya.in.ibm.com>
References: <1231168786.9120.26.camel@marge.simson.net>
	 <1231234297.3806.50.camel@marge.simson.net>
	 <20090106150709.GG4574@dirshya.in.ibm.com>
	 <1231264117.5254.23.camel@marge.simson.net>
	 <20090106184552.GI17198@balbir.in.ibm.com>
	 <1231318755.3899.57.camel@marge.simson.net>
	 <20090107112639.GI4574@dirshya.in.ibm.com>
	 <1231338985.5709.22.camel@marge.simson.net>
	 <20090107153510.GN4574@dirshya.in.ibm.com>
	 <1231402008.5721.37.camel@marge.simson.net>
	 <20090108174655.GQ4574@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 07:00:43 +0100
Message-Id: <1231480843.5570.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 23:16 +0530, Vaidyanathan Srinivasan wrote:

> I agree with the 'visibility' to low level interface that you have
> pointed out.  It will be good to have flags showup at the low level
> interface, but do end users like system administrators would want to
> know and tune these flags?

IMHO there is no difference between these tunings and any other tuning,
the unwary admin can shoot himself in the foot in any number of ways.
The monotonic interface setting sensible flags is fine, but invisible
flags is not.

We may have to agree to disagree.

	-Mike

