Return-Path: <linux-kernel-owner+w=401wt.eu-S1765962AbXHXWr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765962AbXHXWr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 18:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764524AbXHXWrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 18:47:23 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:33062 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762440AbXHXWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 18:47:18 -0400
Date: Fri, 24 Aug 2007 18:46:51 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include linux/pagemap.h in asm-generic/tlb.h
Message-ID: <20070824224651.GA11512@c2.user-mode-linux.org>
References: <20070824184616.GA9442@c2.user-mode-linux.org> <200708241551.41628.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708241551.41628.rob@landley.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 03:51:41PM -0500, Rob Landley wrote:
> It may be non-urgent to you, but it still broke my build. :)
> 
> Acked-by: Rob Landley <rob@landley.net>

Heh, it doesn't seem like -stable material to me, but if there aren't
any screams while it sits in -mm, maybe it's 2.6.23 material.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
