Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706AbZKSLEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbZKSLEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 06:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbZKSLEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 06:04:16 -0500
Received: from corega.com.ru ([195.178.208.66]:48245 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZKSLEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 06:04:15 -0500
Date: Thu, 19 Nov 2009 14:04:13 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] writeback: remove unused nonblocking and congestion checks (pohmelfs)
Message-ID: <20091119110413.GA20188@ioremap.net>
References: <20091118082648.140755818@intel.com> <20091118082845.828021716@intel.com> <20091119081154.GE5922@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119081154.GE5922@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H1.

On Thu, Nov 19, 2009 at 04:11:54PM +0800, Wu Fengguang (fengguang.wu@intel.com) wrote:
> Will you pick up this updated patch? It also removes the unused bdi.

I'm ok with the changes, but I suppose it should be pushed as a single
patchet into the tree, no?

-- 
	Evgeniy Polyakov
