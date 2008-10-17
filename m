Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYJQNmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYJQNmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYJQNl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:41:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58701 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbYJQNl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:41:56 -0400
Date: Fri, 17 Oct 2008 15:40:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/31] proc: move rest of /proc/partitions code to block/genhd.c
Message-ID: <20081017134037.GM19428@kernel.dk>
References: <20081017124711.GP22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017124711.GP22653@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17 2008, Alexey Dobriyan wrote:
> 
> From de5824cba6d479dc525cb24810582e3606e3d166 Mon Sep 17 00:00:00 2001
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Sat, 4 Oct 2008 23:53:21 +0400
> Subject: [PATCH 15/31] proc: move rest of /proc/partitions code to block/genhd.c
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

This and 25/31 look fine to me. How do you plan on merging this? I could
take the two through the block tree, but seems easier just to merge the
entire series through eg Andrew.

Anyway, you can add my Acked-by: to them.

-- 
Jens Axboe

