Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYCVFds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYCVFds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 01:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYCVFdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 01:33:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbYCVFdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 01:33:39 -0400
Date: Fri, 21 Mar 2008 22:33:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Message-Id: <20080321223315.3e0e042f.akpm@linux-foundation.org>
In-Reply-To: <200803220259.48534.rjw@sisk.pl>
References: <200803220259.48534.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008 02:59:47 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Listed regressions statistics:
> 
>   Date          Total  Pending  Unresolved
>   ----------------------------------------
>   2008-03-22      159       35          31
>   2008-03-17      148       38          30
>   2008-03-16      146       42          35
>   2008-03-14      145       45          39
>   2008-03-12      143       51          41
>   2008-03-11      141       58          43
>   2008-03-10      138       66          47
>   2008-03-03      115       65          49
>   2008-02-25       90       51          39
>   2008-02-17       61       45          37
> 
> ...
> 
> Date		: 2007-11-19 14:43 (124 days old)
> Date		: 2008-02-12 14:34 (39 days old)
> Date		: 2008-02-12 12:46 (39 days old)
> Date		: 2008-02-13 10:30 (38 days old)
> Date		: 2008-02-13 12:25 (38 days old)
> Date		: 2008-02-15 04:51 (36 days old)
> Date		: 2008-02-17 06:28 (34 days old)
> Date		: 2008-02-17 09:36 (34 days old)
> Date		: 2008-02-18 11:56 (33 days old)
> Date		: 2008-02-20 09:10 (31 days old)
> Date		: 2008-02-19 12:59 (32 days old)
> Date		: 2008-02-22 10:36 (29 days old)
> Date		: 2008-02-20 08:47 (31 days old)
> Date		: 2008-02-20 16:01 (31 days old)
> Date		: 2008-02-23 18:55 (28 days old)
> Date		: 2008-02-23 18:55 (28 days old)
> Date		: 2008-02-27 (24 days old)
> Date		: 2008-03-02 20:00 (20 days old)
> Date		: 2008-02-28 11:25 (23 days old)
> Date		: 2008-03-05 03:26 (17 days old)
> Date		: 2008-03-12 12:02 (10 days old)
> Date		: 2008-03-14 05:47 (8 days old)
> Date		: 2008-03-17 16:45 (5 days old)
> Date		: 2008-03-20 13:13 (2 days old)
> Date		: 2008-03-20 07:05 (2 days old)
> Date		: 2008-03-21 02:01 (1 days old)
> Date		: 2008-03-21 11:42 (1 days old)
> Date		: 2008-03-21 20:03 (1 days old)
> Date		: 2008-03-21 17:18 (1 days old)
> Date		: 2008-03-20 18:41 (2 days old)
> Date		: 2008-03-21 23:35 (1 days old)


