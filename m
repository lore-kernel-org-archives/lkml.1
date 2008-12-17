Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753155AbYLQXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYLQXNT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYLQXNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:13:05 -0500
Received: from corega.com.ru ([195.178.208.66]:56785 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYLQXNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:13:04 -0500
Date: Thu, 18 Dec 2008 02:13:02 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sfr@canb.auug.org.au, ttb@tentacle.dhs.org, rml@novell.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH] filesystem notification: create fs/notify to contain all fs notification
Message-ID: <20081217231302.GC28283@ioremap.net>
References: <20081217185941.2188.49536.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217185941.2188.49536.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric.

On Wed, Dec 17, 2008 at 01:59:41PM -0500, Eric Paris (eparis@redhat.com) wrote:
> Creating a generic filesystem notification interface, fsnotify, which will be
> used by inotify, dnotify, and eventually fanotify is really starting to
> clutter the fs directory.  This patch simply moves inotify and dnotify into
> fs/notify/inotify and fs/notify/dnotify respectively to make both current fs/
> and future notification tidier.

Looks good, but what with the another patches in the series?

-- 
	Evgeniy Polyakov
