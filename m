Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZFACKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZFACKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 22:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZFACKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 22:10:46 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:48076 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZFACKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 22:10:45 -0400
Subject: Re: [PATCH 17/17] xen: disable MSI
From: Jon Masters <jonathan@jonmasters.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Ky Srinivasan <ksrinivasan@novell.com>,
       Beulich <jbeulich@novell.com>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <adaab4w6f8l.fsf@cisco.com>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
	 <1243409850-21577-18-git-send-email-jeremy@goop.org>
	 <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
	 <20090527211828.GA6166@elte.hu>
	 <alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
	 <adavdnm5hkx.fsf@cisco.com> <20090528072844.4c1db656@lxorguk.ukuu.org.uk>
	 <20090527233807.e7e39e97.akpm@linux-foundation.org>
	 <adaab4w6f8l.fsf@cisco.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sun, 31 May 2009 22:09:50 -0400
Message-Id: <1243822190.14346.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 15:21 -0700, Roland Dreier wrote:
> > Yup.  I presently use "Addresses: <url>" in the changelog.
>  > 
>  > y:/usr/src/git26> git-log | grep '^    Addresses.*bugzilla' | wc -l
>  > 36
>  > 
>  > Formalising that a bit more would be good.
>  > 
>  > Not all patches literally "close" a bugzilla report though.  Sometimes
>  > there's related info in bugzilla but the bug remains.  But
>  > "closes-bug:" is close enough.
> 
> Yes, I deliberately didn't suggest "Fixes-bug:" but I like your
> "Addresses:" language even better.  I'll start using that for any
> commits from now on.

We use "Resolves" and "Related" within Red Hat and Fedora in describing
bugs. I might recommend "Related" as it's already used by a few groups
here, although it's simply another way of saying the same.

Jon.


