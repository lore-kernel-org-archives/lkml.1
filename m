Return-Path: <linux-kernel-owner+w=401wt.eu-S1763733AbXIMTZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763733AbXIMTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbXIMTZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:25:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42302 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbXIMTZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:25:21 -0400
Date: Thu, 13 Sep 2007 21:26:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Chris Wedgwood <cw@f00f.org>, LKML <linux-kernel@vger.kernel.org>,
       davej@redhat.com, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
Message-ID: <20070913192646.GE27146@uranus.ravnborg.org>
References: <20070912232534.GA26868@puku.stupidest.org> <20070913183359.GA27146@uranus.ravnborg.org> <Pine.LNX.4.64.0709131435001.6921@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709131435001.6921@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 02:37:11PM -0400, Robert P. J. Day wrote:
> On Thu, 13 Sep 2007, Sam Ravnborg wrote:
> 
> > Hi Chris.
> >
> > On Wed, Sep 12, 2007 at 04:25:34PM -0700, Chris Wedgwood wrote:
> ...
> > > -----
> > > Add a 'mintree-install' makefile target.
> 
> > I would strongly prefer the name "build-pkg".
> 
> what about "devel-pkg" instead?  that would match fedora's
> "kernel-devel" naming convention.

Does
make devel-pkg
in the kernel make you think:
"This is a minimum package to build an external module".

I guess not.

I suggested "build-pkg" from the rationale that this is a package
used when building something.
Any better suggestions within the context of the kernel are galdly
received.

	Sam
