Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYLKVlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYLKVlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbYLKVlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:41:06 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32952 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbYLKVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:41:04 -0500
Message-ID: <494187FD.8010303@cs.helsinki.fi>
Date: Thu, 11 Dec 2008 23:37:01 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 04/15] kmemleak: Add the slob memory allocation/freeing
 hooks
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com> <20081210182716.30323.13359.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182716.30323.13359.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> This patch adds the callbacks to memleak_(alloc|free) functions from the
> slob allocator.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
