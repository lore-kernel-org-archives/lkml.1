Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYHDKA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYHDKA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYHDKAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:00:49 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16207 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbYHDKAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:00:48 -0400
Date: Mon, 4 Aug 2008 12:00:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Christian Limpach <Christian.Limpach@xensource.com>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xen-blkfront.c: make blkif_ioctl() static
Message-ID: <20080804100046.GD20055@kernel.dk>
References: <20080721193339.GC14846@cs181140183.pp.htv.fi> <4884F9A4.8060201@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4884F9A4.8060201@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21 2008, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
> >This patch makes the needlessly global blkif_ioctl() static.
> >
> >Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >  
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Applied to block tree, thanks.

-- 
Jens Axboe

