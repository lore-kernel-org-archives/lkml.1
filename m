Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbXCHPxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbXCHPxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXCHPxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:53:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbXCHPxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:53:16 -0500
Date: Thu, 8 Mar 2007 07:52:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Christoph Hellwig <hch@infradead.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <200703081211.20662.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703080751490.10832@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il> <200703081042.21454.dada1@cosmosbay.com>
 <20070308102105.GA21119@infradead.org> <200703081211.20662.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Mar 2007, Eric Dumazet wrote:
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> CC: Christoph Hellwig <hch@infradead.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

Except you should fix the subject line when you send it out to Andrew ;)

		Linus
