Return-Path: <linux-kernel-owner+w=401wt.eu-S937354AbXG0QgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937354AbXG0QgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934631AbXG0QgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:36:12 -0400
Received: from [198.99.130.12] ([198.99.130.12]:52692 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934570AbXG0QgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:36:11 -0400
Date: Fri, 27 Jul 2007 12:35:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/68] 0 -> NULL, for arch/um
Message-ID: <20070727163541.GA6930@c2.user-mode-linux.org>
References: <200707270945.LAA17372@ifs.emn.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707270945.LAA17372@ifs.emn.fr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 11:45:56AM +0200, Yoann Padioleau wrote:
> When comparing a pointer, it's clearer to compare it to NULL than to 0.

ACK

>  sys-i386/fault.c   |    2 +-
>  sys-x86_64/fault.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Except you should probably diff from the top of the kernel tree.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
