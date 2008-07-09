Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYGIEuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYGIEuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYGIEt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:49:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42161 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYGIEtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:49:55 -0400
Date: Tue, 8 Jul 2008 21:49:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
Message-Id: <20080708214903.b783ba84.randy.dunlap@oracle.com>
In-Reply-To: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik>
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Jul 2008 23:37:43 +0200 (CEST) Rafael J. Wysocki wrote:

> Unresolved regressions
> ----------------------
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
> Subject		: x86_64 boot hang when CONFIG_NUMA=n
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2008-06-05 21:50 (34 days old)
> References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
> 		  http://lkml.org/lkml/2008/6/11/355
> 		  http://lkml.org/lkml/2008/6/15/117
> 		  http://marc.info/?l=linux-kernel&m=121287638527452&w=2
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>

I've spent quite some time trying to bisect this problem, but to no avail.
I don't expect to spend more time on it, so I suppose you can just mark it as dead.

Thanks for your efforts, YH.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
