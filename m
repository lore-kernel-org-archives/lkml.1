Return-Path: <linux-kernel-owner+w=401wt.eu-S1765051AbXGTOKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765051AbXGTOKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762408AbXGTOKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:10:00 -0400
Received: from [198.99.130.12] ([198.99.130.12]:52587 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761570AbXGTOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:10:00 -0400
Date: Fri, 20 Jul 2007 10:09:43 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, sam@ravnborg.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fallout from kbuild changes
Message-ID: <20070720140943.GC6534@c2.user-mode-linux.org>
References: <20070720010116.GB21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720010116.GB21668@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 02:01:16AM +0100, Al Viro wrote:
> 	Change in 'kbuild: do section mismatch check on full vmlinux'
> should've been replicated in arch/um/Makefile.

ACK

	Jeff

-- 
Work email - jdike at linux dot intel dot com
