Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbXCIJFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbXCIJFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXCIJFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:05:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36474 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbXCIJFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:05:12 -0500
Date: Fri, 9 Mar 2007 09:05:10 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
Message-ID: <20070309090510.GA24908@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1173419792.32234.131.camel@localhost.localdomain> <20070309065055.GA18056@pazke.donpac.ru> <20070309075308.GE8798@infradead.org> <20070309090218.GB18056@pazke.donpac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309090218.GB18056@pazke.donpac.ru>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 12:02:19PM +0300, Andrey Panin wrote:
> Kernel compilation with Intel compiler is (was ?) supported.
> This patch will break it.

It was only put in under the premise that they'll fix whatever breaks,
we're not going to put any maintaince border on us to hack around
broken propritary compilers.

