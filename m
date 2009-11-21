Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZKULXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZKULXn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 06:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZKULXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 06:23:42 -0500
Received: from tservice.ru ([195.178.208.66]:59535 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZKULXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 06:23:42 -0500
Date: Sat, 21 Nov 2009 14:23:46 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] writeback: remove unused nonblocking and congestion checks (pohmelfs)
Message-ID: <20091121112346.GC23974@ioremap.net>
References: <20091118082648.140755818@intel.com> <20091118082845.828021716@intel.com> <20091119081154.GE5922@localhost> <20091119110413.GA20188@ioremap.net> <20091120015317.GB6028@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120015317.GB6028@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Nov 20, 2009 at 09:53:17AM +0800, Wu Fengguang (fengguang.wu@intel.com) wrote:
> > On Thu, Nov 19, 2009 at 04:11:54PM +0800, Wu Fengguang (fengguang.wu@intel.com) wrote:
> > > Will you pick up this updated patch? It also removes the unused bdi.
> > 
> > I'm ok with the changes, but I suppose it should be pushed as a single
> > patchet into the tree, no?
> 
> Either way works. I would submit a single patchset that includes the
> generic ones and the fs specific patches that have not been picked up
> into their fs tree :)

Please push it within your patchset to eliminate merge dependencies if
any. Thank you.

-- 
	Evgeniy Polyakov
