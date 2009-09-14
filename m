Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbZINCP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbZINCP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZINCPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:15:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbZINCPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:15:25 -0400
Date: Sun, 13 Sep 2009 22:15:10 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, ioband-devel@lists.sourceforge.net,
       corsetproject@googlegroups.com, kunai@linux-foundation.jp,
       osonoi@linux-foundation.jp
Subject: Re: IO controller Mini-Summit 2009
Message-ID: <20090914021509.GB4070@redhat.com>
References: <20090826.203251.260094379.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826.203251.260094379.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26 2009 at  7:32am -0400,
Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> Hi All,
> 
> As I have notified before, The 1st Linux IO controller Mini-Summit
> will be held in Tokyo Japan on Oct 17 -- day before the 9th Linux
> kernel summit. So I would like to propose the following topics for 
> the mini-summit and discuss about them.
> 
> - Multiple IO controller development projects
>   - There are two activities for the development of IO controller,
>     Vivek's io-controller and dm-ioband. Do we have to pick one of
>     them to put into the mainline? How to advance the development?

This has been said by others before but: there is no reason the above
line of discussion can't happen on LKML et. al. (preferably now).
Deferring the discussion until Oct 17 guarantees that no solution would
be merged into 2.6.32.  This would be quite unfortunate considering how
far Vivek's IO Controller has come.   Aren't there also doubts about
whether the appropriate upstream people will be able to attend this
mini-summit?

Mike
