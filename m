Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZINJlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZINJlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZINJlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:41:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54578 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbZINJlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:41:16 -0400
Date: Mon, 14 Sep 2009 11:41:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: bdev->bd_inode_backing_dev_info?
Message-ID: <20090914094119.GZ14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This looks a bit odd, what is the purpose of that? It also appears
currently to be unused, it's never set to anything but NULL.

-- 
Jens Axboe

