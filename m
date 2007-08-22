Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbXHVRcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbXHVRcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764815AbXHVRcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:32:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35459 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762528AbXHVRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:32:31 -0400
Date: Wed, 22 Aug 2007 10:30:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcin Kowalczyk <qrczak@knm.org.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] setpgid(child) fails if the child was forked by
 sub-thread
Message-Id: <20070822103052.d06e2645.randy.dunlap@oracle.com>
In-Reply-To: <20070822172436.GA1635@tv-sign.ru>
References: <bug-8921-10286@http.bugzilla.kernel.org/>
	<20070822082517.321edfa5.akpm@linux-foundation.org>
	<20070822165539.GA191@tv-sign.ru>
	<20070822100802.c2c202f9.randy.dunlap@oracle.com>
	<20070822172436.GA1635@tv-sign.ru>
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

On Wed, 22 Aug 2007 21:24:36 +0400 Oleg Nesterov wrote:

> On 08/22, Randy Dunlap wrote:
> >
> > On Wed, 22 Aug 2007 20:55:39 +0400 Oleg Nesterov wrote:
> > 
> > 
> > so "fixes http://bugzilla.kernel.org/show_bug.cgi?id=8921"  ??
> 
> Hopefully yes... should I add some note at /bugzilla.kernel.org?

I think that it can wait until Marcin confirms that it's fixed
(if he does so soon), then mark 8921 as fixed.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
