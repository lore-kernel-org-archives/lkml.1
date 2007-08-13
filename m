Return-Path: <linux-kernel-owner+w=401wt.eu-S945062AbXHMURe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945062AbXHMURe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032409AbXHMUQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:16:54 -0400
Received: from THUNK.ORG ([69.25.196.29]:38196 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032273AbXHMUQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:16:53 -0400
Date: Mon, 13 Aug 2007 16:16:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Message-ID: <20070813201629.GE21719@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Arjan van de Ven <arjan@infradead.org>,
	Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
	Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <1186984174.10249.7.camel@localhost> <200708131933.10125.m.kozlowski@tuxland.pl> <1187026955.2688.4.camel@laptopd505.fenrus.org> <m3odhb46rk.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3odhb46rk.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 08:41:03PM +0200, Krzysztof Halasa wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > The maintainer info should be in the source file itself!
> 
> Nope, it should be outside of the (downloadable) tarball, because
> once someone get a tarball you can't update the data in it.
> This is fine WRT source (which is static given a version) but
> doesn't work for fast-changing data.

But the maintainers file is in the tarball today.  If someone wants to
take the information from the latest git tree, gather it up into a
single html file, and put it on the web, more power to them.  But it
seems that the master source of the data should be the source file.

      	       	      	     	    - Ted
