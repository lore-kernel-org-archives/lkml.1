Return-Path: <linux-kernel-owner+w=401wt.eu-S2993071AbXDYUUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993071AbXDYUUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993076AbXDYUUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:20:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32295 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993071AbXDYUT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:19:59 -0400
Date: Wed, 25 Apr 2007 13:22:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bbpetkov@yahoo.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-Id: <20070425132245.01a1c6c4.randy.dunlap@oracle.com>
In-Reply-To: <20070420060250.GB3967@gollum.tnic>
References: <20070413091422.GA15426@zmei.tnic>
	<20070414091341.7665d8b0.randy.dunlap@oracle.com>
	<20070415071050.GA4002@gollum.tnic>
	<20070417104907.GA6155@gollum.tnic>
	<20070418090320.3786edd6.randy.dunlap@oracle.com>
	<20070419062059.GA3974@gollum.tnic>
	<20070419085336.c029b87c.randy.dunlap@oracle.com>
	<20070420060250.GB3967@gollum.tnic>
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

On Fri, 20 Apr 2007 08:02:50 +0200 Borislav Petkov wrote:

> > > > Are other people seeing these warning messages ??
> > > Hm, is anyone building the manpages target at all?
> > 
> > Other than the 2 of us... I couldn't say.
> 
> By the way, can we consider the item 
> "- clean up Documentation/DocBook/, fix warnings that occur on make *docs."  
> from the KJ TODO list as now done?

OK, although a few of them may not be fixed until soon after 2.6.21
is released and pending patches are applied.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
