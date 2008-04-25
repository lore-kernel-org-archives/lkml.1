Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYDYKqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYDYKqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYDYKqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:46:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28142 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYDYKqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:46:25 -0400
Date: Fri, 25 Apr 2008 12:46:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] unexport blk_max_pfn
Message-ID: <20080425104619.GM12774@kernel.dk>
References: <20080423095248.GO28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423095248.GO28933@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23 2008, Adrian Bunk wrote:
> blk_max_pfn can now be unexported.

Applied

-- 
Jens Axboe

