Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbXJJT5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbXJJT5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbXJJT52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:57:28 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55404 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632AbXJJT51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:57:27 -0400
Date: Wed, 10 Oct 2007 21:58:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       parisc-linux-request@lists.parisc-linux.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: parisc arch makefile clean-up needed [Was: cleaning up "make headers_install" for various architectures]
Message-ID: <20071010195856.GC2791@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0710101234340.32502@localhost.localdomain> <20071010095954.79c39a73.randy.dunlap@oracle.com> <Pine.LNX.4.64.0710101324230.6071@localhost.localdomain> <20071010183858.GA2270@uranus.ravnborg.org> <20071010193827.GE2746@fattire.cabal.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010193827.GE2746@fattire.cabal.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 03:38:27PM -0400, Kyle McMartin wrote:
> On Wed, Oct 10, 2007 at 08:38:58PM +0200, Sam Ravnborg wrote:
> > parisc arch Makefile needs some love and care...
> > 
> 
> It basically hasn't been touched since 2.4,
Seems I did 25% of the changes since day 0 (counted from when
we started to use git for the kernel).

> I already have a patch to
> clean up a lot of things when Randy pointed it out a while ago. Thanks
> for the reminder, I'll queue it for 2.6.24.

Thanks -I assume you coordinate with Matthew.

	Sam
