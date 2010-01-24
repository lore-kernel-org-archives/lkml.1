Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633Ab0AXXZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0AXXZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726Ab0AXXZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:25:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:49506 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750758Ab0AXXZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:25:07 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1/4JLdN78j4AEKHQ2Rn5XmPXq1WzJNcY/ZDhw8L/q
	fXL0ZT0Z3o30Io
Date: Mon, 25 Jan 2010 01:21:37 +0200 (EET)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #15040] High cpu temperature with 2.6.32
In-Reply-To: <q60Z28d_9yH.A.bxH.PZMXLB@chimera>
Message-ID: <alpine.LNX.2.00.1001250115420.6323@localhost.localdomain>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.bxH.PZMXLB@chimera>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will let you know when this bug is fixed in a regular kernel release. I 
just tested 2.6.32.5 and the bug persists. BTW, Arjan, I think this bug 
will be biting other people too, see the following thread: 
http://bugs.archlinux.org/task/17771


Dimitris


On Sun, 24 Jan 2010, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15040
> Subject		: High cpu temperature with 2.6.32
> Submitter	: Dimitrios Apostolou <jimis@gmx.net>
> Date		: 2010-01-06 17:39 (19 days old)
> References	: http://marc.info/?l=linux-kernel&m=126279952723036&w=4
> Handled-By	: Arjan van de Ven <arjan@infradead.org>
> Patch		: http://patchwork.kernel.org/patch/71962/
>
>
