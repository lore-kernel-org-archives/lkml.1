Return-Path: <linux-kernel-owner+w=401wt.eu-S1751329AbZIYEGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbZIYEGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZIYEGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:06:31 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42206 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZIYEG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:06:28 -0400
Date: Fri, 25 Sep 2009 06:06:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/10] Current writeback patch queue
Message-ID: <20090925040631.GP23126@kernel.dk>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com> <20090925025527.GA10487@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925025527.GA10487@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25 2009, Wu Fengguang wrote:
> On Thu, Sep 24, 2009 at 10:40:26PM +0800, Jens Axboe wrote:
> > Hi,
> > 
> > This is the current writeback patch queue. Most of the patches
> > have already been reviewed and acked, but please take a look
> > at the ones that have not (and ack/comment as necessary).
> > 
> > Wu, this one is still missing the 5/6 patch from your latest posting,
> > Please double check and re-submit that bit. Thanks!
> 
> OK, updated patch to add the missing label and the wbc->for_kupdate
> check to avoid jumping from !for_kupdate to the for_kupdate code

Thanks, looks good, applied now.

-- 
Jens Axboe

