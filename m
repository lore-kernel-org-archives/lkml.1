Return-Path: <linux-kernel-owner+w=401wt.eu-S1766861AbXEBR3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766861AbXEBR3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766863AbXEBR3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:29:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41776 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766861AbXEBR3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:29:50 -0400
Date: Wed, 2 May 2007 18:29:34 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070502172934.GA17782@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502094707.4197ab7a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 09:47:07AM -0700, Andrew Morton wrote:
> > That doesn't constitute using it.
> 
> Andi, there was a huge amount of discussion about all this in September last
> year (subjects: *markers* and *LTTng*). The outcome of all that was, I
> believe, that the kernel should have a static marker infrastructure.

Only when it's actually useable.  A prerequisite for merging it is
having an actual trace transport infrastructure aswell as a few actually
useful tracing modules in the kernel tree.

Let this count as a vote to merge the markers once we have the infrastructure
above ready, it'll be very useful then.
