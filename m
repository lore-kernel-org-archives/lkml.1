Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZDMSCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZDMSCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZDMSCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:02:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43459 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbZDMSCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:02:32 -0400
Date: Mon, 13 Apr 2009 20:02:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix SG_IO to return a proper error value
Message-ID: <20090413180231.GB5178@kernel.dk>
References: <20090403204911X.fujita.tomonori@lab.ntt.co.jp> <20090413192604N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413192604N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13 2009, FUJITA Tomonori wrote:
> Ping?
> 
> This patch is necessary to return a proper error for applications
> issuing READ requests with a bogus buffer.

I'll add it.

-- 
Jens Axboe

