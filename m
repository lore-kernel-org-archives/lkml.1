Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbXJaTUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbXJaTUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbXJaTUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:20:33 -0400
Received: from brick.kernel.dk ([87.55.233.238]:6784 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbXJaTUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:20:33 -0400
Date: Wed, 31 Oct 2007 20:20:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.4.24-rc1-git: crash on shutdown/unmount?
Message-ID: <20071031192028.GG11514@kernel.dk>
References: <200710311917.21441.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710311917.21441.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31 2007, Alistair John Strachan wrote:
> Hi Jens,
> 
> I guessed from the oops that you might have an idea what's causing this oops 
> on shutdown/unmount. The git version (describe), a screenshot showing the 
> oops, a config, and dmesg for a booted kernel are available from:
> 
> http://devzero.co.uk/~alistair/oops-20071031/
> 
> I went back to -rc1 and it still happens there too. If you need any more 
> information or want me to bisect it, please let me know.

I do, I'll post a patch shortly. Just need to test it first.

-- 
Jens Axboe

