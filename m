Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYCLIxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYCLIxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 04:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYCLIxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 04:53:44 -0400
Received: from mga05.intel.com ([192.55.52.89]:28054 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751391AbYCLIxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 04:53:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,486,1199692800"; 
   d="scan'208";a="532561641"
Subject: Re: 2.6.25-rc4-git3: Reported regressions from 2.6.24
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>
In-Reply-To: <200803100132.57160.rjw@sisk.pl>
References: <200803100132.57160.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Wed, 12 Mar 2008 16:51:14 +0800
Message-Id: <1205311874.3215.29.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-10 at 01:32 +0100, Rafael J. Wysocki wrote:
> [Due to the lack of time for reviewing all of the email threads related to the
> regressions marked as "unresolved" below, I might have missed some patches
> fixing them.  If you are involved in debugging/fixing any of them, please let
> me know if I should update the list.  Thanks!]
> 
> This message contains a list of some regressions from 2.6.24 reported since
> 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.24, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.
> 
> 
> Listed regressions statistics:
> 
>   Date          Total  Pending  Unresolved
>   ----------------------------------------
>   2008-03-10      138       66          47
>   2008-03-03      115       65          49
>   2008-02-25       90       51          39
>   2008-02-17       61       45          37
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10013
> Subject		: tbench regression in 2.6.25-rc1
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-02-15 02:52
> References	: http://lkml.org/lkml/2008/2/14/546
> Handled-By	: Eric Dumazet <dada1@cosmosbay.com>
> 		  David Miller <davem@davemloft.net>
> Patch		: http://lkml.org/lkml/2008/2/18/66
> 		  http://lkml.org/lkml/2008/2/18/117
> 
The latest patch is http://lkml.org/lkml/2008/2/20/83. 2.6.25-rc5 doesn't
include it. tbench regression still exists on my tigerton machine.

-yanmin



