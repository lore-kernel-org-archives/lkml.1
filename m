Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZA3I4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZA3I4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZA3Izy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:55:54 -0500
Received: from mout.perfora.net ([74.208.4.194]:64660 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZA3Izy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:55:54 -0500
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Nathanael Hoyle <nhoyle@hoyletech.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1233302861.6061.14.camel@marge.simson.net>
References: <1233294584.28741.2.camel@localhost>
	 <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>
	 <1233297635.17301.11.camel@localhost>
	 <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr>
	 <1233302349.17301.27.camel@localhost>
	 <1233302861.6061.14.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 03:55:47 -0500
Message-Id: <1233305747.17301.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18kH75jUUh2dgsN7czWgZLKpq+zlqM9v8zKgeo
 csZ1nLlAXZIGveV+bUOCivGX1+kaZaKHHzxRAd22ELZYdmXVZH
 axWFE0wxiakqvjvlLjMyFic/4bNzNjc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 09:07 +0100, Mike Galbraith wrote:
> On Fri, 2009-01-30 at 02:59 -0500, Nathanael Hoyle wrote:
> 
> > I am running foldingathome under it at the moment, and it seems to be
> > improving the situation somewhat, but I still need/want to test with
> > Mike's referenced patches.
> 
> You will most definitely encounter evilness running SCHED_IDLE tasks in
> a kernel without the SCHED_IDLE fixes.
> 
> 	-Mike
> 

Mike,

Any reason not to apply this fairly simple patch against the 2.6.27
series kernel I'm running now? Are there other relevant changes you're
aware of in the later kernel revs for this problem?

Thanks,
-Nathanael

