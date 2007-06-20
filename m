Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbXFTPSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbXFTPSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXFTPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:18:17 -0400
Received: from [198.99.130.12] ([198.99.130.12]:57220 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbXFTPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:18:16 -0400
Date: Wed, 20 Jun 2007 11:17:53 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH 2/2] UML - Add stack usage monitoring
Message-ID: <20070620151753.GA6728@c2.user-mode-linux.org>
References: <20070619184245.GA10567@c2.user-mode-linux.org> <20070619195003.GA11718@c2.user-mode-linux.org> <20070619131441.01b5ae4b.akpm@linux-foundation.org> <200706201606.58331.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706201606.58331.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 04:06:58PM +0200, Blaisorblade wrote:
> Oh, it's exactly what CONFIG_DEBUG_STACK_USAGE does for i386... (not sure if 
> you were still wondering...).

Where?  The only usage in i386 that I see is thread_info.h zeroing stacks
as they are allocated.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
