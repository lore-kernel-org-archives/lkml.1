Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0BBUht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:37:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0BBUhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:37:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [Bug #15192] netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
Date: Tue, 2 Feb 2010 21:38:41 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <d3IDKWHT5gE.A.Z-B.V7hZLB@chimera> <1265011447.6220.15.camel@marge.simson.net>
In-Reply-To: <1265011447.6220.15.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022138.41960.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Mike Galbraith wrote:
> On Mon, 2010-02-01 at 01:22 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Yes, it should remain open.  We're currently waiting for some data from
> Lin Ming.  The regression itself isn't making much sense.. a kernel with
> NEWIDLE disabled should show the same performance, but does not.  

Well, thanks for the update.

Rafael
