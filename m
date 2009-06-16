Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbZFPGkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbZFPGkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZFPGkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:40:32 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51087 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZFPGkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:40:32 -0400
Date: Tue, 16 Jun 2009 08:40:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: unsik Kim <donari75@gmail.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       joerg@dorchain.net, geert@linux-m68k.org, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Subject: Re: [PATCH] mg_disk: seperate mg_disk.h again
Message-ID: <20090616064033.GK11363@kernel.dk>
References: <1245131994-21518-1-git-send-email-donari75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245131994-21518-1-git-send-email-donari75@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16 2009, unsik Kim wrote:
> eec9462088a26c046d4db3100796a340a50890b8 fold mg_disk.h into mg_disk.c,
> but mg_disk platform driver needs private data for operation. This also
> make mg_disk.c as machine independent. Seperate only needed structure and
> defines to mg_disk.h

Applied

-- 
Jens Axboe

