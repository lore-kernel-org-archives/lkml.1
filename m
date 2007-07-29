Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbXG2T3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbXG2T3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764527AbXG2T3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:29:14 -0400
Received: from brick.kernel.dk ([80.160.20.94]:22167 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764357AbXG2T3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:29:13 -0400
Date: Sun, 29 Jul 2007 21:30:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove mm/filemap.c:file_send_actor()
Message-ID: <20070729193017.GK32258@kernel.dk>
References: <20070729145752.GR16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729145752.GR16817@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29 2007, Adrian Bunk wrote:
> This patch removes the no longer used file_send_actor().

Good catch, applied!

-- 
Jens Axboe

