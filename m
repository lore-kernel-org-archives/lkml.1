Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbZCPKTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbZCPKTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZCPKTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:19:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42064 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZCPKTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:19:24 -0400
Date: Mon, 16 Mar 2009 06:19:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de
Subject: Re: [PATCH 5/7] writeback: move the default backing_dev_info out
	of readahead
Message-ID: <20090316101921.GA9510@infradead.org>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-6-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236868428-20408-6-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 03:33:46PM +0100, Jens Axboe wrote:
> It belongs in mm/backing-dev.c

Good cleanup, should be queued up ASAP.

