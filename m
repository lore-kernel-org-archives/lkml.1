Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbXIRRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbXIRRVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760117AbXIRRVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:21:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64313 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbXIRRVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:21:02 -0400
Date: Tue, 18 Sep 2007 10:18:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be, satyam@infradead.org
Subject: Re: 2.6.23-rc6-mm1 (watchdog)
Message-Id: <20070918101839.e8af8c28.randy.dunlap@oracle.com>
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 01:18:41 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> 
> 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.

> Changes since 2.6.23-rc4-mm1:
> 
>  git-watchdog.patch

Still complains with:

drivers/watchdog/core/watchdog_dev.c:84: warning: format '%i' expects type 'int', but argument 5 has type 'size_t'

which Satyam posted a patch for:
  http://lkml.org/lkml/2007/9/3/212
and Wim replied that he had applied it... ???
  http://lkml.org/lkml/2007/9/4/145  (maybe to wrong tree/branch ?)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
