Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZFIDpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZFIDpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 23:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZFIDpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 23:45:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59655 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZFIDpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 23:45:41 -0400
Date: Tue, 9 Jun 2009 05:45:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tj@kernel.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: needs to set the residual length of a bidi
	request.
Message-ID: <20090609034542.GU11363@kernel.dk>
References: <20090609105709A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609105709A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09 2009, FUJITA Tomonori wrote:
> This is against for-2.6.31.
> 
> This should fix the following problem:
> 
> http://marc.info/?l=linux-scsi&m=124449210813269&w=2

Thanks, applied

-- 
Jens Axboe

