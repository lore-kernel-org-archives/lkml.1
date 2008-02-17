Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYBQTwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYBQTwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYBQTwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:52:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44437 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752073AbYBQTwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:52:43 -0500
Date: Sun, 17 Feb 2008 20:52:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       len.brown@intel.com
Subject: Re: 2.6.25-rc2-mm1 (build failure)
Message-ID: <20080217195256.GC6115@elf.ucw.cz>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080216213225.f5f71c35.randy.dunlap@oracle.com> <20080216214627.e8248706.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216214627.e8248706.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> > 
> > When SMP=n, x86_64 build gets:
> > 
> > arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
> > (.text+0xfd7f): undefined reference to `setup_trampoline'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > 
> 
> Thanks.  Say hello to Pavel.

Sorry, I was in mountains, with electricity 5 hours a day... I believe
this was solved already?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
