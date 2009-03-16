Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZCPBC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZCPBC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 21:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZCPBCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 21:02:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:1030 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZCPBCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 21:02:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,369,1233561600"; 
   d="scan'208";a="394724892"
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
In-Reply-To: <MiincthRUSI.A.eKC.F4BvJB@chimera>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 09:02:53 +0800
Message-Id: <1237165373.2807.140.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-15 at 03:01 +0800, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.28, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed already,
> please let me know.
> 
> If you know of any other unresolved regressions from 2.6.28, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.
> 
> Each entry from the list will be sent additionally in an automatic reply to
> this message with CCs to the people involved in reporting and handling the
> issue.
> 
> 
> Listed regressions statistics:
> 
>   Date          Total  Pending  Unresolved
>   ----------------------------------------
>   2009-03-14      124       36          32
>   2009-03-03      108       33          28
>   2009-02-24       95       32          24
>   2009-02-14       85       33          27
>   2009-02-08       82       45          36
>   2009-02-04       66       51          39
>   2009-01-20       38       35          27
>   2009-01-11       13       13          10
> 
> 
> Unresolved regressions
> ----------------------

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12831
> Subject         : Hot/Fn Keys do not work EEEPC 1000HE (eeepc_laptop)
> Submitter       : Matthew <pyther@pyther.net>
> Date            : 2009-03-07 10:05 (8 days old)

patch is available at
http://bugzilla.kernel.org/show_bug.cgi?id=12831#c11

thanks,
rui

