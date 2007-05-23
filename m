Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbXEWRAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbXEWRAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbXEWRAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:00:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51803 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452AbXEWRAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:00:08 -0400
Date: Wed, 23 May 2007 10:04:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
Message-Id: <20070523100416.93835196.randy.dunlap@oracle.com>
In-Reply-To: <46541F65.9060507@msgid.tls.msk.ru>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
	<46541F65.9060507@msgid.tls.msk.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 15:03:01 +0400 Michael Tokarev wrote:

> Randy Dunlap wrote:
> > 
> > Add "notime" boot option to prevent timing data from being printed on
> > each printk message line.
> 
> That's a good source of confusion.  To me, "notime" means something
> like "don't bother calculating time", instead of the proposed
> behavior.  Can't it be something like 'nologts' (no log timestamps)
> or nots or notimestamps or nologtime instead?

"nologtime" is OK with me.  or does it confuse people in a
different way?  Anyone else?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
