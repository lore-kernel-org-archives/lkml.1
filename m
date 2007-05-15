Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbXEOWAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbXEOWAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbXEOWAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:00:32 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34487 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbXEOWAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:00:32 -0400
Date: Tue, 15 May 2007 17:52:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix uml-x86_64
Message-ID: <20070515215255.GA5198@c2.user-mode-linux.org>
References: <E1Ho2oS-0003Sw-9Y@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ho2oS-0003Sw-9Y@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 08:36:00PM +0100, Al Viro wrote:
> 
> __NR_syscall_max is done in x86_64 asm-offsets; do an equivalent in
> uml kern_constants.h
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

ACK

-- 
Work email - jdike at linux dot intel dot com
