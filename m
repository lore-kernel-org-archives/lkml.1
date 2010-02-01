Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0BAH5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 02:57:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:48989 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751845Ab0BAH5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 02:57:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ODa8a69VOVXyTjsnMTqKqtMxeff7wFQqZ5efNab
	xBDgie6mSvA7OJ
Subject: Re: [Bug #14950] tbench regression with 2.6.33-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <d3IDKWHT5gE.A.GDD.o8hZLB@chimera>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	 <d3IDKWHT5gE.A.GDD.o8hZLB@chimera>
Content-Type: text/plain
Date: Mon, 01 Feb 2010 08:57:15 +0100
Message-Id: <1265011035.6220.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.69999999999999996
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

Yes, it should remain open.  Looking for places to trim overhead without
injuring other things.  The regression is a moving target on my HW.

	-Mike

