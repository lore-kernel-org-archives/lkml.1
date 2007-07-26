Return-Path: <linux-kernel-owner+w=401wt.eu-S934134AbXGZNIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134AbXGZNIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762706AbXGZNIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:08:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2753 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760168AbXGZNIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:08:13 -0400
Date: Thu, 26 Jul 2007 10:42:46 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Etienne Lorrain <etienne_lorrain@yahoo.fr>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [GIT PULL] Bug- and documentation fixes for the x86 setup code
Message-ID: <20070726104246.GD10208@ucw.cz>
References: <200707181858.l6IIwA27032630@tazenda.hos.anvin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707181858.l6IIwA27032630@tazenda.hos.anvin.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> H. Peter Anvin (5):
>       [x86 setup] MAINTAINERS: document x86 setup code git tree
>       [x86 setup] build/tools.c: fix comment
>       [x86 setup] Fix assembly constraints
>       [x86 setup] VGA: Clear the Protect bit before setting the vertical height
>       [x86 setup] Save/restore DS around invocations of INT 10h

Are there / were there known problems with running new setup code on
AMD Geode and similar strange cpus? I tried to get wyse thin client to
work, and it worked ok in 2.6.22, but something broke early in boot
(doublefault?) with newer versions.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
