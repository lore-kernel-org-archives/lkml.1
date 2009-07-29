Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZG2T2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZG2T2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 15:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZG2T2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 15:28:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:32952 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbZG2T2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 15:28:14 -0400
Date: Wed, 29 Jul 2009 21:28:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org, anton@samba.org
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090729192814.GT4148@kernel.dk>
References: <20090729112509.GN4148@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729112509.GN4148@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29 2009, Jens Axboe wrote:
> Building the perf tool is somewhat involved on sparc64
> though, since 64-bit versions of zlib/libelf/bfd aren't
> directly available (at least on debian 5.x). But once you
> get there, it runs :-). Would it be easier/functional
> to build 32-bit userland perf instead?

Same is true on ppc64, btw. How are others handling this?

-- 
Jens Axboe

