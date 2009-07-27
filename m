Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZG0Usy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZG0Usy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZG0Usx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:48:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38170 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbZG0Usx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:48:53 -0400
Date: Mon, 27 Jul 2009 22:48:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: unsik Kim <donari75@gmail.com>
Cc: bzolnier@gmail.com, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mg_disk: Add missing ready status check on mg_write()
Message-ID: <20090727204852.GJ4148@kernel.dk>
References: <200907031516.51893.bzolnier@gmail.com> <1248322878-3804-1-git-send-email-donari75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248322878-3804-1-git-send-email-donari75@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23 2009, unsik Kim wrote:
> When last sector is written, ready bit of status register should be
> checked.

Added (with Barts ack), thanks!

-- 
Jens Axboe

