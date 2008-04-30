Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYD3G6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYD3G6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYD3G62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:58:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21362 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbYD3G61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:58:27 -0400
Date: Wed, 30 Apr 2008 08:58:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] docbook: fix bio missing parameter
Message-ID: <20080430065823.GL12774@kernel.dk>
References: <Pine.LNX.4.64.0804292012140.18219@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804292012140.18219@shark.he.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29 2008, Randy.Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix fs/bio.c kernel-doc parameter warning:
> Warning(linux-2.6.25-git14//fs/bio.c:972): No description found for parameter 'reading'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks Randy, applied

-- 
Jens Axboe

