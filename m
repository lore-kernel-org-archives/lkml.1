Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZINQgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZINQgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbZINQgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:36:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:45087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756028AbZINQgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:36:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+m5opfuIemRnwDPSbrdfuL4I7PFDXZyD/uEVOPFK
	VilBoxP54Z/7aU
Subject: Re: INGO Why you remove  set_user_nice() from kernel/kthread.c
From: Mike Galbraith <efault@gmx.de>
To: Chris Friesen <cfriesen@nortel.com>
Cc: pavel@pavlinux.ru, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Network Development list <netdev@vger.kernel.org>
In-Reply-To: <4AAE6FD7.5070401@nortel.com>
References: <200909141742.45487.pavel@pavlinux.ru>
	 <1252937140.6500.11.camel@marge.simson.net>  <4AAE5D60.2080703@nortel.com>
	 <1252943123.12986.70.camel@marge.simson.net>  <4AAE6FD7.5070401@nortel.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 18:36:20 +0200
Message-Id: <1252946180.6404.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 10:31 -0600, Chris Friesen wrote:

> I've added netdev to the CC list.  Maybe some of the people there have
> an opinion on what the default priority should be for ksoftirqd.

Good idea.

	-Mike

