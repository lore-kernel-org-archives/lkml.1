Return-Path: <linux-kernel-owner+w=401wt.eu-S932735AbYEULRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbYEULRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761269AbYEULQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:16:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43899 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760847AbYEULQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:16:48 -0400
Date: Wed, 21 May 2008 13:16:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh@veritas.com>, Glauber Costa <gcosta@redhat.com>,
       Glauber Costa <glommer@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix app crashes after SMP resume
Message-ID: <20080521111642.GC5028@ucw.cz>
References: <Pine.LNX.4.64.0805131420030.5781@blonde.site> <20080513140237.GA18798@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513140237.GA18798@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> hehe :)
> 
> ob'note: would be nice to have the suspend+resume self-test/debug patch 
> below upstream. It programs the RTC to a 5 second sleep and resumes the 
> computer, which then self-wakeups afterwards.

The version with pony, yes! :-)

> Subject: suspend+resume self-test
> From: David Brownell <david-b@pacbell.net>
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

ACK. Perhaps you should send it to Andrew for a merge? Or maybe Rafael
wants to add it to his patch queue?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
