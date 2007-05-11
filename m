Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbXEKGyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbXEKGyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXEKGyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:54:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48612 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbXEKGyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:54:10 -0400
Date: Fri, 11 May 2007 07:53:53 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
       Christoph Hellwig <hch@infradead.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] lguest feedback tidyups
Message-ID: <20070511065353.GA25182@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	virtualization <virtualization@lists.linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
	Pekka J Enberg <penberg@cs.helsinki.fi>
References: <1178846246.23513.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178846246.23513.21.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 11:17:26AM +1000, Rusty Russell wrote:
>     - But the cost was high: lots of __force casts 8(

That sounds like something is very fishy.

