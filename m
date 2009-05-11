Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZEKJG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZEKJG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbZEKJGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:06:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39588 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbZEKJGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:06:34 -0400
Date: Mon, 11 May 2009 11:06:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] block: completion releated functions cleanup
Message-ID: <20090511090634.GP4694@kernel.dk>
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11 2009, FUJITA Tomonori wrote:
> This is a minor cleanup on the completion releated functions. It is on
> the top of Tejun's unify request processing model patchset.

Looks good to me, queued up.

-- 
Jens Axboe

