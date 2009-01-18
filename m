Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZARWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZARWPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZARWPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:15:33 -0500
Received: from verein.lst.de ([213.95.11.210]:42064 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbZARWPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:15:32 -0500
Date: Sun, 18 Jan 2009 23:15:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
Subject: Re: new barrier warnings in 2.6.29-rc1
Message-ID: <20090118221512.GA10645@lst.de>
References: <20090112154634.GA15730@lst.de> <496C0915.6000107@kernel.org> <20090113084229.GL30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113084229.GL30821@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still see the warnings with Jens' patch, but now only one instead of
two per mount.
