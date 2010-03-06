Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0CFWjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 17:39:07 -0500
Received: from thunk.org ([69.25.196.29]:51207 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab0CFWjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 17:39:04 -0500
Date: Sat, 6 Mar 2010 17:38:51 -0500
From: tytso@mit.edu
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100306223851.GH6000@thunk.org>
Mail-Followup-To: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
 <1267889034.24025.4.camel@segulix>
 <alpine.LFD.2.00.1003060937370.31447@localhost.localdomain>
 <1267902406.24025.50.camel@segulix>
 <alpine.LFD.2.00.1003061127060.31447@localhost.localdomain>
 <20100306204953.GG6000@thunk.org>
 <20100306205235.2e4dacb4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306205235.2e4dacb4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 08:52:35PM +0000, Alan Cox wrote:
> > They want the benefits of lots of testers, without wanting to be
> > courteous to those testers.
> 
> Except for the small rather important detail that the Nouveau developers
> didn't ask for it to be merged in the first place.
> 

*Someone* on the Red Hat/Fedora team made the decision to make it
available on a very popular distribution to get more testing.  And
they did it without putting in the necessary versioning so that kernel
testers could test upstream kernels.  That, in my book, is an
anti-social thing to do.  Fedora isn't alone, of course; Ubuntu does
this as well, and worse yet, with proprietary binary drivers.  But
just because Ubuntu does something worse, doesn't mean that Fedora
should get a free pass for what they did.

						- Ted
