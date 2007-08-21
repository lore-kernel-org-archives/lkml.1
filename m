Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbXHUJep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbXHUJep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXHUJea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:34:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55087 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754239AbXHUJeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:34:02 -0400
Date: Tue, 21 Aug 2007 09:37:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20070821073710.GB7258@elf.ucw.cz>
References: <CB1BB3E1-68AB-4F7E-B8F8-466C4E471856@mac.com> <766922.14722.qm@web36601.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <766922.14722.qm@web36601.mail.mud.yahoo.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ergo the only  
> > people who should be writing security policy for deployment are those  
> > people who have studied and trained in the stuff.  Those people are  
> > also known as "security professionals".
> 
> If only security professionals can use the system you have failed
> to provide a general purpose facility. It may have value in limited
> circumstances but it is not for everybody.

But that's okay. Maybe SElinux is not simple enough to use for
everyone, but that does not mean you can't auto-generate policy from
something else, "easy to understand".

IOW smack may be great idea, but you written it in wrong language. You
written it in C, while you should have written it in SELinux policy
language (and your favourite scripting language as frontend).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
