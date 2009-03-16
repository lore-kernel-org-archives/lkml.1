Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbZCPKYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbZCPKYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZCPKXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:23:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47813 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbZCPKXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:23:50 -0400
Date: Mon, 16 Mar 2009 11:23:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de
Subject: Re: [PATCH 5/7] writeback: move the default backing_dev_info out
	of readahead
Message-ID: <20090316102348.GQ27476@kernel.dk>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-6-git-send-email-jens.axboe@oracle.com> <20090316101921.GA9510@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316101921.GA9510@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16 2009, Christoph Hellwig wrote:
> On Thu, Mar 12, 2009 at 03:33:46PM +0100, Jens Axboe wrote:
> > It belongs in mm/backing-dev.c
> 
> Good cleanup, should be queued up ASAP.

Yep, will place that at the front as well.

-- 
Jens Axboe

