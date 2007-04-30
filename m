Return-Path: <linux-kernel-owner+w=401wt.eu-S1423164AbXD3JL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423164AbXD3JL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423185AbXD3JL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:11:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51773 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423164AbXD3JL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:11:27 -0400
Date: Mon, 30 Apr 2007 10:11:21 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>, akpm@osdl.org
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: condingstyle, was Re: utrace comments
Message-ID: <20070430091121.GC31397@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Roland McGrath <roland@redhat.com>, akpm@osdl.org,
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430040213.BF9901801A4@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've separated this out under a new subject because some style issues
that so far aren't documented explicitly are in doubt here, and Roland
wants and Answer from Andrew.

We also should put clauses on this into CodingStyle.


On Sun, Apr 29, 2007 at 09:02:13PM -0700, Roland McGrath wrote:
> > 	The coding style here is wrong.  The else should be on the line
> > 	of the closing brace.  
> 
> I can ordinarily ignore syntax, but this is an abomination in the sight
> of the Lord and always will be.  Fortunately, it's far from being 100%
> consistently used in the kernel already.  People are welcome to change
> the code after I submit it, but I just can't make myself write it that
> way, sorry.

> > 	This doesn't follow kernel coding style at all, we always
> > 	put the && or || operators at the end of the closing line.
> 
> I could swear I've been "corrected" in the opposite direction on this one.
> It is not mentioned in Documentation/CodingStyle, and the existing kernel
> code is far from consistent on it.  I really don't care which way it is,
> but I'd like clear authoritative direction from Linus and Andrew before I
> bother with it.

