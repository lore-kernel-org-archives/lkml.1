Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbXFPHEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbXFPHEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXFPHEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:04:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1765 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751138AbXFPHDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:03:52 -0400
Date: Fri, 15 Jun 2007 13:36:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Sean <seanlkml@sympatico.ca>, david@lang.hm,
       Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname matching
Message-ID: <20070615133644.GK9442@ucw.cz>
References: <20070609032822.bc420a84.seanlkml@sympatico.ca> <637419.18785.qm@web36615.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <637419.18785.qm@web36615.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The question is: why not just extend SELinux to include AA functionality
> > rather than doing a whole new subsystem.
> 
> Because, as hard as it seems for some people to believe,
> not everyone wants Type Enforcement. SELinux is a fine
> implementation of type enforcement, but if you don't want
> what it does it would be silly to require that it be
> used in order to accomplish something else, like name based
> access control.
> 
> If the same things made everyone feel "secure" there would be
> no optional security facilities (audit, cryptfs, /dev/random, ACLs).
> It appears that the AA folks are sufficiently unimpressed with
> SELinux they want to do something different. I understand that

Actually, no. AA was started at time when SELinux was very different
from today, and now AA people have installed base of 'happy users'
they are trying to support.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
