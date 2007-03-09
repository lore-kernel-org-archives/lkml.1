Return-Path: <linux-kernel-owner+w=401wt.eu-S965584AbXCIHxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584AbXCIHxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXCIHxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:53:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54841 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965554AbXCIHxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:53:08 -0500
Date: Fri, 9 Mar 2007 07:53:08 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
Message-ID: <20070309075308.GE8798@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1173419792.32234.131.camel@localhost.localdomain> <20070309065055.GA18056@pazke.donpac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309065055.GA18056@pazke.donpac.ru>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 09:50:56AM +0300, Andrey Panin wrote:
> On 068, 03 09, 2007 at 04:56:32PM +1100, Rusty Russell wrote:
> > __builtin_types_compatible_p() has been around since gcc 2.95,
> 
> but it's not available in Intel C compiler IIRC :(

So what?

