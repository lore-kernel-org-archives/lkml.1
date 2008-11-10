Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYKJMnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYKJMnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbYKJMnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:43:10 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37943 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbYKJMnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:43:09 -0500
Date: Mon, 10 Nov 2008 13:41:20 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] block: fix add_partition() error path
Message-ID: <20081110124119.GG26778@kernel.dk>
References: <4917D4AB.4080401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4917D4AB.4080401@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10 2008, Tejun Heo wrote:
> Partition stats structure was not freed on devt allocation failure
> path.  Fix it.

Thanks, applied 1-3 for 2.6.28

-- 
Jens Axboe

