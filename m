Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbXIRRnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbXIRRnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760302AbXIRRnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:43:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29002 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760343AbXIRRnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:43:08 -0400
Date: Tue, 18 Sep 2007 10:41:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       wim@iguana.be, satyam@infradead.org
Subject: Re: 2.6.23-rc6-mm1 (watchdog)
Message-Id: <20070918104144.63dd24b4.randy.dunlap@oracle.com>
In-Reply-To: <20070918101839.e8af8c28.randy.dunlap@oracle.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070918101839.e8af8c28.randy.dunlap@oracle.com>
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

On Tue, 18 Sep 2007 10:18:39 -0700 Randy Dunlap wrote:

> On Tue, 18 Sep 2007 01:18:41 -0700 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> > 
> > 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> 
> > Changes since 2.6.23-rc4-mm1:
> > 
> >  git-watchdog.patch
> 
> Still complains with:
> 
> drivers/watchdog/core/watchdog_dev.c:84: warning: format '%i' expects type 'int', but argument 5 has type 'size_t'

Please ignore.  wrong directory  :(


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
