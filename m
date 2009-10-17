Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZJRSkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZJRSkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 14:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbZJRSkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 14:40:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50386 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbZJRSkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 14:40:14 -0400
Date: Sat, 17 Oct 2009 19:16:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Cc: Josh Triplett <josh@joshtriplett.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Jon Bernard <jbernard@debian.org>, Jan Blunck <jblunck@suse.de>,
       Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>, ltt-dev@lists.casi.polymtl.ca,
       rp@svcs.cs.pdx.edu, linux-kernel@vger.kernel.org
Subject: Re: Userspace RCU 0.2.3
Message-ID: <20091017171615.GD1526@ucw.cz>
References: <20091014223657.GC6458@Krystal> <20091015000225.GG6763@linux.vnet.ibm.com> <20091015023925.GA27959@Krystal> <20091015090042.GA7677@feather> <4AD75EA6.8080809@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD75EA6.8080809@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-15 13:40:54, Pierre-Marc Fournier wrote:
> Josh Triplett wrote:
> > 
> > Even Debian has given up on real 386 systems at this point, primarily
> > because system libraries like glibc have; 486 and better represents the
> > bare minimum required at this point.  I don't know of any distributions
> > supporting real 386 systems at this point, and doing so would represent
> > a major undertaking.
> > 
> 
> What about embedded systems? Anyone know if some 386 chips, perhaps even
> in smp configurations, are still in use in those?

smp 386: definitely not.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
