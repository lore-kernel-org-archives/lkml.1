Return-Path: <linux-kernel-owner+w=401wt.eu-S1766897AbXDSRjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766897AbXDSRjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766895AbXDSRjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:39:05 -0400
Received: from quechua.inka.de ([193.197.184.2]:55155 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766899AbXDSRjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:39:04 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <Pine.LNX.4.64.0704181515290.25880@alien.or.mcafeemobile.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Heaay-0004Tl-00@calista.eckenfels.net>
Date: Thu, 19 Apr 2007 19:39:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Pine.LNX.4.64.0704181515290.25880@alien.or.mcafeemobile.com> you wrote:
> Top (VCPU maybe?)
>    User
>        Process
>            Thread

The problem with that is, that not all Schedulers might work on the User
level. You can think of Batch/Job, Parent, Group, Session or namespace
level. That would be IMHO a generic Top, with no need for a level above.

Greetings
Bernd
