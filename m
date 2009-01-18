Return-Path: <linux-kernel-owner+w=401wt.eu-S1765430AbZARIYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765430AbZARIYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761339AbZARIYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:24:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54467 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759746AbZARIYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:24:11 -0500
Date: Sun, 18 Jan 2009 09:24:02 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Gergely Imreh <imrehg@gmail.com>
Subject: Re: [Bug #12391] Processor does not go below C2 state until
	usb.autosuspend is enabled
Message-ID: <20090118082401.GC1944@ucw.cz>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.LMC.safaJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nHCfeC0YLrE.A.LMC.safaJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-11 12:41:04, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12391
> Subject		: Processor does not go below C2 state until usb.autosuspend is enabled
> Submitter	: Gergely Imreh <imrehg@gmail.com>
> Date		: 2009-01-09 02:35 (3 days old)

Are you sure that's regression? IIRC usb.autosuspend is needed for
C3. It is certainly needed if you have *any* usb device plugged in.

What hw is that?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
