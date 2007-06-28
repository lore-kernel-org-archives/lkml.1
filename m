Return-Path: <linux-kernel-owner+w=401wt.eu-S1765621AbXF2MaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765621AbXF2MaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761205AbXF2MaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:30:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1578 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758051AbXF2MaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:30:02 -0400
Date: Thu, 28 Jun 2007 18:19:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070628181943.GG5339@ucw.cz>
References: <46732124.80509@novell.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <f5mmuu$4d4$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5mmuu$4d4$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

One more...

> 2. This is argument #1 in a different guise and I find it about as weak.
> Pathname-based access control has strengths and weaknesses.  I think
> users and Linux distributions are in a better position to evaluate those
> tradeoffs than L-K.  Competition is good.

It took you quite a lot of time to realize AA does not do IPC (and all
the implications of that). I do not think Linux _users_ can do
informed decision here. Novell marketing did too good job here.

Heck, even I am not sure if I understand the implications of not doing
IPC confinement. Is shared memory commonly used in a way that allows
exploiting? I know it is a problem, and you probably could kill init
from hacked apache..... but what would you do to break out of jail?

							Pavel
(please cc me)
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
