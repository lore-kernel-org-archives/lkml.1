Return-Path: <linux-kernel-owner+w=401wt.eu-S941549AbXHJUHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941549AbXHJUHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936048AbXHJUHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:07:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51936 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760669AbXHJUHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:07:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
Date: Fri, 10 Aug 2007 22:16:34 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
References: <46B9F664.9060600@googlemail.com> <200708102124.01218.rjw@sisk.pl> <Pine.SOC.4.64.0708102220290.14225@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0708102220290.14225@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708102216.35182.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 August 2007 21:29, Meelis Roos wrote:
> > 1. Is that with the same .config you sent me previously?
> 
> Yes, just ran it through make oldconfig again, included below.
> 
> > 2. What exactly is the consequence of this warning?
> 
> I hope no big trouble (i.e. only a warning during make *config) but I 
> haven't boot-tested rc2 and newer kernels yet because it's a remote 
> machine. Will try some day now.

What happens if you run "make" with the config created with the
"make oldconfig"?  Does the warning show up again or not?

Greetings,
Rafael
