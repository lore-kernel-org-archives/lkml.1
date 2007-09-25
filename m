Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbXIYPfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbXIYPfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbXIYPfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:35:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22583 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbXIYPfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:35:15 -0400
Date: Tue, 25 Sep 2007 08:33:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux/mutex.h: unclear reference to convention
Message-Id: <20070925083348.b8860569.randy.dunlap@oracle.com>
In-Reply-To: <713129.73007.qm@web52009.mail.re2.yahoo.com>
References: <713129.73007.qm@web52009.mail.re2.yahoo.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 01:11:05 -0700 (PDT) Matti Linnanvuori wrote:

> If you want to maintain the convention of documenting the interface only in .c files, 
> you should write the convention in so many places in .h files that no one could overlook it.
> But I think the convention is bad and it would be better to document the interface also in
> .h files where it is defined. The convention is bad because it requires people to jump to
> other files to understand .h files.

Then we would have comments in multiple places and they would
undoubtedly get out of sync.  When that happens, which one do
you use?  Bad.

I'll find some place to document this convention anyway.  Maybe
it will help.

---
~Randy
Phaedrus says that Quality is about caring.
