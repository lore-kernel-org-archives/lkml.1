Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbXFZQZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbXFZQZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXFZQZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:25:43 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:44532 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbXFZQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:25:42 -0400
Date: Tue, 26 Jun 2007 12:25:41 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070626162541.GA5464@delft.aura.cs.cmu.edu>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKCEKCEMAC.davids@webmaster.com> <or4pl0iz15.fsf@oliva.athome.lsd.ic.unicamp.br> <20070622013417.GT21478@ftp.linux.org.uk> <20070622041949.GA15625@thunk.org> <orejk4edfl.fsf@oliva.athome.lsd.ic.unicamp.br> <20070625132853.GH10008@csclub.uwaterloo.ca> <orhcov7qsz.fsf@oliva.athome.lsd.ic.unicamp.br> <20070626041013.GG24745@delft.aura.cs.cmu.edu> <orvedb4433.fsf@oliva.athome.lsd.ic.unicamp.br> <ormyyn40o9.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ormyyn40o9.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 04:47:34AM -0300, Alexandre Oliva wrote:
> On Jun 26, 2007, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:
> > On Jun 26, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:
> >> You could argue that they do not restrict copying, distribution
> >> and modification of the sources in general, only of the specific copy
> >> they distribute.
> 
> > "We don't oppose that you do any of these things, once you get the
> > source code.  We just make it difficult (hopefully impossible) that
> > you'll get to the source code in the first place."
> 
> Actually, they could even claim you don't need the source code to make
> modifications.  The license even says the source code is the most
> convenient form to make modifications, not the only form.  Now, that
> the others suck rocks is not their fault, is it? ;-)

GPLv2 section 3.
    The source code for a work means the preferred form of the work for
    making modifications to it.

I believe this states that the source code has to be in the preferred
form for making modifications and not some other form that sucks rocks.

As far as your argument that making it difficult or impossible to obtain
the source code could be in compliance. I don't see how (intentionally)
making something difficult could not be interpreted as a restriction so
it still violates section 6 of the GPLv2.

And yes, I do realize that you intentionally tried to come up with your
example to somehow bring tivoization to the source code. However
although the GPLv2 doesn't address the freedom to use (and specifically
does not grants the user a right to run a modified version of the
program on some specific piece of hardware), it does (try) to address
the recipients rights to copy, distribute and modify.

Jan

