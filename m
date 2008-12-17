Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753229AbYLQXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbYLQXYU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYLQXYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:24:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41945 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYLQXYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:24:07 -0500
Subject: Re: [PATCH] filesystem notification: create fs/notify to contain
 all fs notification
From: Eric Paris <eparis@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sfr@canb.auug.org.au, ttb@tentacle.dhs.org, rml@novell.com,
        kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081217231302.GC28283@ioremap.net>
References: <20081217185941.2188.49536.stgit@paris.rdu.redhat.com>
	 <20081217231302.GC28283@ioremap.net>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 18:23:50 -0500
Message-Id: <1229556230.3384.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dropping ttb@tentacle.dhs.org and rml@novell.com since their e-mails
were wrong in MAINTAINERS.  I sent them both requests to fix it.]

On Thu, 2008-12-18 at 02:13 +0300, Evgeniy Polyakov wrote:

> 
> Looks good, but what with the another patches in the series?

This can stand pretty well on its own and I figure if it gets into
2.6.29 everyone will at least be patching files on the right path.  I'm
hoping to have the complete inotify, dnotify, audit, and even fanotify
out and hopefully ready for 2.6.30.

Since this is reasonably useful today and I know others are looking at
inotify I figured I'd get it in as soon as possible so when I do try to
push all my crap that'll be the only conflict, not this moving of
files...

-Eric



