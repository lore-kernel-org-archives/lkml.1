Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0BAIEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:04:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:59442 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752534Ab0BAIEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:04:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+q0wVNN4mqH4Efimh3u71UBYrv4OpuHLYxRppQ0e
	WOViP8R9BQeXNc
Subject: Re: [Bug #15192] netperf ~50% regression with 2.6.33-rc1, bisect
 to 1b9508f
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <d3IDKWHT5gE.A.Z-B.V7hZLB@chimera>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	 <d3IDKWHT5gE.A.Z-B.V7hZLB@chimera>
Content-Type: text/plain
Date: Mon, 01 Feb 2010 09:04:07 +0100
Message-Id: <1265011447.6220.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68000000000000005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 01:22 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).

Yes, it should remain open.  We're currently waiting for some data from
Lin Ming.  The regression itself isn't making much sense.. a kernel with
NEWIDLE disabled should show the same performance, but does not.  

	-Mike

