Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbZKFEcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbZKFEcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 23:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759233AbZKFEcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 23:32:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:39023 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759232AbZKFEcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 23:32:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+uWJdSXtqukKpyRI8UY8aBBVyjSxWNTHDjl8V7VW
	tgdE3xc0T8GBJm
Subject: Re: [PATCH -tip] sched: fix bug that task run on a wrong and
 unallowed cpu
From: Mike Galbraith <efault@gmx.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Eric Paris <eparis@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1257481838.6394.56.camel@marge.simson.net>
References: <4AF39B6D.50001@cn.fujitsu.com>
	 <1257481838.6394.56.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 05:32:33 +0100
Message-Id: <1257481953.6394.57.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btw, I missed the fact that you were seeing this in latest tip,
otherwise I'd have warned you :)

	-Mike

