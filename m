Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYGXS65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYGXS65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYGXS6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:58:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYGXS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:58:48 -0400
Date: Thu, 24 Jul 2008 14:58:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, Alexander Viro <aviro@redhat.com>,
       Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: parser: add const to parser token table (resend)
Message-ID: <20080724185842.GA25246@infradead.org>
References: <1216916533.5376.1.camel@localhost.localdomain> <alpine.LFD.1.10.0807241147160.3237@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807241147160.3237@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:48:55AM -0700, Linus Torvalds wrote:
> 
> Btw, the reason I didn't even look at this at first is that there is no 
> such thing as a "parser" in the kernel,

Well, there's lib/parser.c and include/linux/parser.h..

