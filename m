Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYK3Rbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYK3Rbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 12:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYK3Rb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 12:31:27 -0500
Received: from waste.org ([66.93.16.53]:40329 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYK3Rb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 12:31:26 -0500
Subject: Re: [PATCH 04/15] kmemleak: Add the slob memory allocation/freeing
	hooks
From: Matt Mackall <mpm@selenic.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081129104328.16726.74354.stgit@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	 <20081129104328.16726.74354.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Sun, 30 Nov 2008 11:30:59 -0600
Message-Id: <1228066259.3196.66.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-29 at 10:43 +0000, Catalin Marinas wrote:
> This patch adds the callbacks to memleak_(alloc|free) functions from the
> slob allocator.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Pekka Enberg <penberg@gmail.com>
> Cc: Matt Mackall <mpm@selenic.com>

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

