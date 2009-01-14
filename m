Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbZANJIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbZANJIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZANJHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:07:51 -0500
Received: from tservice.ru ([195.178.208.66]:54510 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZANJHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:07:49 -0500
Date: Wed, 14 Jan 2009 12:07:48 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Valdis.Kletnieks@vt.edu
Cc: David Rientjes <rientjes@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090114090747.GA22347@ioremap.net>
References: <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <alpine.DEB.2.00.0901131459001.22290@chino.kir.corp.google.com> <20090113233502.GA31490@ioremap.net> <6507.1231907037@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6507.1231907037@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:23:57PM -0500, Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> > I wonder how do you expect users to guess via libastral that even
> > adjusted score does not work, since it happens that task is so special,
> > that it can not be killed :)
> 
> What does your patch do if one user has a process 'foo' that they're willing
> to have die first, and a process 'bar' that absolutely can't be killed..
> 
> Meanwhile, another user has a 'must die first' process 'bar', and a 'must not
> die' process 'foo'.
> 
> Methinks your patch needs libastral as well?

My patch needs an administrator to setup the name pattern.
Undocumented magic deeply hidden in the calculus of the badness() is quite different.

-- 
	Evgeniy Polyakov
