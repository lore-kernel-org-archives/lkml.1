Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0BAPrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:47:47 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:34258 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0BAPrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:47:45 -0500
Message-ID: <4B66F79E.1040606@mandriva.org>
Date: Mon, 01 Feb 2010 17:47:42 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [Bug #14482] kernel BUG at fs/dcache.c:670 +lvm +md +ext3
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.85G.9HiZLB@chimera>
In-Reply-To: <de962C6zBxL.A.85G.9HiZLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01.02.2010 02:43, Rafael J. Wysocki skrev:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14482
> Subject		: kernel BUG at fs/dcache.c:670 +lvm +md +ext3
> Submitter	: Alexander Clouter<alex@digriz.org.uk>
> Date		: 2009-10-23 10:30 (101 days old)
> References	: http://lkml.org/lkml/2009/10/23/50
>
>

Afaik this is the same issue as the one referenced here:

http://lkml.org/lkml/2010/1/28/292

The patch in the above thread should fix the issue.

--
Thomas
