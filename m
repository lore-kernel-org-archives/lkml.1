Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYBRMvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYBRMvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbYBRMvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:51:25 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21230 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759407AbYBRMvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:51:24 -0500
Date: Mon, 18 Feb 2008 13:51:20 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make struct def_blk_aops static
Message-ID: <20080218125120.GZ23197@kernel.dk>
References: <20080217081644.GC3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217081644.GC3848@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17 2008, Adrian Bunk wrote:
> This patch makes the needlessly global struct def_blk_aops static.

Applied

-- 
Jens Axboe

