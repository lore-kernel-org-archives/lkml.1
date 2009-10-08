Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbZJHUE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbZJHUE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933387AbZJHUE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:04:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095AbZJHUE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:04:57 -0400
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
From: James Bottomley <James.Bottomley@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>
	 <1254862442.4383.183.camel@mulgrave.site>
	 <1255012399.4187.24.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>
	 <1255031298.4187.260.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 16:04:04 -0400
Message-Id: <1255032244.4187.267.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 12:55 -0700, Linus Torvalds wrote:
> On Thu, 8 Oct 2009, James Bottomley wrote:
> > 
> > Could I remind you that at the last kernel summit I was the one
> > advocating for holding drivers out of tree until they met our standards
> > and you were the one who told me not to do this ... Jon even captured
> > it:
> 
> What the hell is wrong with you?
> 
> You're bringing up total red herrings that have nothing to do with 
> anything.
> 
> My point is:
>  - that's not just another driver. That's FIFTY THOUSANDS LINES OF 
>    LARGELY INFRASTRUCTURE CRAP.
> 
>  - I'm not arguing that we shouldn't merge the driver
> 
>  - I'm arguing that you damn well should have used the merge window for 
>    something like this!
> 
> What part of "it's already -rc3, and you're pushing 50kloc of crap that 
> almost nobody will care about" can you not understand?
> 
> What part of "merge window" do you have issues with?

OK, you're saying the merge window exemption should only apply to
drivers which meet our coding standards.

That's fine, I can live with that ... and that's how we'll operate in
future.

> What part of "sure, I'll take new drivers after the merge window, but COME 
> &*^@ ON!" do you have trouble understanding?

What does the ^@ mean again?

> Stop bringing up totally irrelevant crap.

James


