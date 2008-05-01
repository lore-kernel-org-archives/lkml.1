Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYEAJQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYEAJQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYEAJQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:16:19 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:17881 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800AbYEAJQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:16:18 -0400
From: Frans Pop <elendil@planet.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Date: Thu, 1 May 2008 11:16:11 +0200
User-Agent: KMail/1.9.9
Cc: arjan@infradead.org, bunk@kernel.org, torvalds@linux-foundation.org,
       rjw@sisk.pl, davem@davemloft.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, rostedt@goodmis.org
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080430000338.50548884@infradead.org> <20080501011346.522f9846.akpm@linux-foundation.org>
In-reply-To: <20080501011346.522f9846.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011116.13645.elendil@planet.nl>
X-OriginalArrivalTime: 01 May 2008 09:16:16.0009 (UTC) FILETIME=[02194F90:01C8AB6C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 30 Apr 2008 00:03:38 -0700 Arjan van de Ven <arjan@infradead.org>
> wrote:
>> I would argue instead that we don't know which bugs to fix first.
> 
> How about "a bug which we just added"?

And leave unfixed all the regressions introduced in earlier kernel versions 
and known at the time of the release of that version but still present in 
the current version? Not to mention all the other bugs reported by users of 
recent stable versions?

> One which is repeatable. 
> Repeatable by a tester who is prepared to work with us on resolving it.

That can be true for not-so-recently introduced bugs too.

There are so many bugs out there and developers tend to focus on new ones 
leaving a lot of others unattended, both important and not so important 
ones.

Which ones should someone focus on? Maybe on the ones that someone (helped) 
introduce him/herself. Maybe that should even sometimes be prioritized over 
introducing new bugs^W^W^Wdoing new development.
