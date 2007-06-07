Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbXFGMCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbXFGMCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbXFGMCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:02:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3829 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751100AbXFGMC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:02:29 -0400
Date: Thu, 7 Jun 2007 10:42:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Antonio Mignolli <antoniomignolli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: lid switch hangs notebook
Message-ID: <20070607104208.GA8245@ucw.cz>
References: <a790ea7a0703120753i232ace2bg7272fa479b821e32@mail.gmail.com> <20070315110606.741c2dc4.akpm@linux-foundation.org> <200704131553.54787.bjorn.helgaas@hp.com> <a790ea7a0706040357g799e8756ue758e95d5b460307@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a790ea7a0706040357g799e8756ue758e95d5b460307@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The problem reported below has not been solved,
> I tried with the last stable kernel 2.6.21.3.
> 
> But it seems not to be an ACPI issue,
> I removed ACPI support from the kernel,
> and still have the problem.
> What else could be?

Does it hang the box if you close/open the lid on grub prompt?

Also try disabling apm.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
