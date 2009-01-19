Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbZASUVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbZASUVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZASUVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:21:21 -0500
Received: from brick.kernel.dk ([93.163.65.50]:25285 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZASUVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:21:21 -0500
Date: Mon, 19 Jan 2009 21:19:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: new barrier warnings in 2.6.29-rc1
Message-ID: <20090119201951.GB30821@kernel.dk>
References: <20090112154634.GA15730@lst.de> <496C0915.6000107@kernel.org> <20090113084229.GL30821@kernel.dk> <20090118221512.GA10645@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118221512.GA10645@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18 2009, Christoph Hellwig wrote:
> I still see the warnings with Jens' patch, but now only one instead of
> two per mount.

Hmm weird, I'll run and fix it locally.

-- 
Jens Axboe

