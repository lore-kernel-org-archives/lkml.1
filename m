Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbYBRMtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbYBRMtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYBRMtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:49:45 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21215 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYBRMtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:49:45 -0500
Date: Mon, 18 Feb 2008 13:49:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make blk-core.c:request_cachep static again
Message-ID: <20080218124941.GX23197@kernel.dk>
References: <20080213212914.GB3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213212914.GB3383@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13 2008, Adrian Bunk wrote:
> request_cachep needlessly became global.

Thanks Adrian, applied all three in this series.

-- 
Jens Axboe

