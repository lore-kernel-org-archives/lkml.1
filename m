Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbXFTPUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbXFTPUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbXFTPUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:20:36 -0400
Received: from [198.99.130.12] ([198.99.130.12]:57240 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbXFTPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:20:35 -0400
Date: Wed, 20 Jun 2007 11:20:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH 2/2] UML - Add stack usage monitoring
Message-ID: <20070620152029.GB6728@c2.user-mode-linux.org>
References: <20070619184245.GA10567@c2.user-mode-linux.org> <20070619115422.de61abd5.akpm@linux-foundation.org> <200706201618.56604.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706201618.56604.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 04:18:56PM +0200, Blaisorblade wrote:
> In Italy we say "habits are hard to die"...

"Old habits are hard to kill"

I'm working on it.

> In the end: are you interested in this stuff? I'm busy right now but
> can work to apply these changes after this thursday
> (i.e. tomorrow). I'd need to get Jeff's patchset to fix it.

I actually prefer to do them by hand (although that does have
disadvantages, as we've just seen).  The reason is that it makes me
look at the code line-by-line, and I often see other things which need
fixing.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
