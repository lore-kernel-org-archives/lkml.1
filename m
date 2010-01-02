Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370Ab0ABFdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab0ABFdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 00:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027Ab0ABFda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 00:33:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:50757 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab0ABFd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 00:33:29 -0500
Message-ID: <4B3EDA94.3040005@windriver.com>
Date: Fri, 01 Jan 2010 23:33:08 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, jbarnes@virtuousgeek.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: linux-next: Tree for December 31 (kgdb)
References: <20091231112314.a51e160b.sfr@canb.auug.org.au> <20091231110747.5efc1efa.randy.dunlap@oracle.com> <12c511ca0912311120i3f60fccas3487c1f47b5cf3c3@mail.gmail.com>
In-Reply-To: <12c511ca0912311120i3f60fccas3487c1f47b5cf3c3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jan 2010 05:33:08.0493 (UTC) FILETIME=[10E9BBD0:01CA8B6D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> The kgdb bits break ia64 (and any other architecture without an
> <asm/kgdb.h> too):
>
>   

Certainly this was not intended.   It is properly fixed now in and
folded into a number of the kgdb patches so everything will properly
bisect.  It is updated in kgdb-next.

Thanks,
Jason.
