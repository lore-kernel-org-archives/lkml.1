Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbXFOMJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbXFOMJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXFOMJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:09:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46508 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbXFOMJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:09:43 -0400
Date: Fri, 15 Jun 2007 14:09:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rob Landley <rob@landley.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615120926.GD6269@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <20070614122031.4751a52b@the-village.bc.nu> <20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706141907.11957.rob@landley.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rob Landley <rob@landley.net> wrote:

> > uhm, so if the MPAA and the RIAA pays for another nice piece of 
> > legislation that extends the power of copyright owners, do you find 
> > it morally justified to use those powers, as long as it's argued to 
> > be in favor of some long-term goal that you judge to be moral, even 
> > if it results in some "temporary injustice"?
> 
> Turnabout is fair play, and unilateral disarmament is a bad strategy 
> in a mexican standoff?
> 
> Finding it morally justified to _have_ powers is not the same as 
> finding it morally justified to _use_ powers you have anyway.  Lots of 
> companies (like Red Hat) amass defensive software patent portfolios 
> because the patent system is so screwed up.

but the GPLv3 definitely takes action against Tivo. It's not "defensive" 
in any way. It is outright hostile, it irreversibly cuts off certain 
people from being to distribute GPLv3-ed software alongside with certain 
types of hardware that the FSF's president does not like. (who, 
incidentally, is a mathematician who last wrote significant free 
software perhaps a decade ago, and who thus must have a great and 
thorough understanding of how hardware and software works today and who 
must also have a deep knowledge about what makes the free software 
community tick.)

The GPLv2 never did this kind of restriction _of other works_. Yes, you 
can use copyright law to control other works and thus (if the affected 
work is a hardware device for example) to control the _use_ of the free 
software, but it is _wrong_. The GPLv2 specifically said, in section 0:

  Activities other than copying, distribution and modification are not
  covered by this License; they are outside its scope.

guess why this section has been completely removed from the GPLv3, 
without a replacement?

	Ingo
