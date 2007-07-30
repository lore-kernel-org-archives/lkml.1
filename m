Return-Path: <linux-kernel-owner+w=401wt.eu-S967953AbXG3T6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967953AbXG3T6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966817AbXG3T6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:58:37 -0400
Received: from [198.99.130.12] ([198.99.130.12]:38152 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965688AbXG3T6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:58:37 -0400
Date: Mon, 30 Jul 2007 15:54:30 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UML - Console should handle spurious IRQS
Message-ID: <20070730195430.GC9810@c2.user-mode-linux.org>
References: <20070727152344.GA6776@c2.user-mode-linux.org> <46ABE473.2030507@aladin.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46ABE473.2030507@aladin.ro>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 03:50:59AM +0300, Eduard-Gabriel Munteanu wrote:
> Jeff Dike wrote:
> >The previous DEBUG_SHIRQ patch missed one case.  The console doesn't
> >set its host descriptors non-blocking.
> 
> Sorry, things looked okay when I tested on my UML environment (Puppy 
> Linux). Some xterms popped around (because I was using "con=xterm") and 
> the system was usable, so it gave me no indication something was wrong.

NP, I was just cc-ing you because you had an interest in the problem,
having already fixed most of it.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
