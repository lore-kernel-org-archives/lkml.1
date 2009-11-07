Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZKGEp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZKGEp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 23:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760236AbZKGEp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 23:45:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:35324 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760211AbZKGEp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 23:45:56 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Z3CYiB99ZYAyWx2ndXd0W1Wx71c86PSHvWTvCLs
	nntFiNjArNk2bg
Subject: Re: Intermittent early panic in try_to_wake_up
From: Mike Galbraith <efault@gmx.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <4AF4B614.3080708@gmail.com>
References: <4AE0EBBD.6090005@gmail.com>
	 <1256289781.22979.11.camel@marge.simson.net>  <4AF36364.9090004@gmail.com>
	 <1257485650.6233.17.camel@marge.simson.net>  <4AF4B614.3080708@gmail.com>
Content-Type: text/plain
Date: Sat, 07 Nov 2009 05:45:57 +0100
Message-Id: <1257569157.6390.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 19:49 -0400, Kevin Winchester wrote:

> The patch below does not apply to mainline, unless I'm doing something wrong.
> It's against -tip, I assume?  Is it just as applicable to mainline?

It was mainline, but I had the scheduler pull request and another in for
testing as well.  Linus has pulled, so it'll apply now, with offsets.

	-Mike

