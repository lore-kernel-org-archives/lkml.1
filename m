Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbXHQNzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbXHQNzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXHQNzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 09:55:32 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55476 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXHQNzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 09:55:31 -0400
Date: Fri, 17 Aug 2007 09:54:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Joe Perches <joe@perches.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] hostfs: Remove pointless if statement
Message-ID: <20070817135446.GA5725@c2.user-mode-linux.org>
References: <20070815235825.GB17004@redhat.com> <1187224811.5906.55.camel@localhost> <20070816145210.GD6670@c2.user-mode-linux.org> <alpine.LFD.0.999.0708171208060.3666@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708171208060.3666@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 12:24:23PM +0530, Satyam Sharma wrote:
> We normally use "comments" for that, not dead code that a compiler
> then elids ;-)

I'd argue that comments are for when you can't make the code
self-explanatory.

> [PATCH] hostfs: Remove pointless if statement
> 
> And replace with comment saying we don't handle ctime.
> Also some codingstyle while I was there.

I'll forward this upstream.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
