Return-Path: <linux-kernel-owner+w=401wt.eu-S1751398AbXJUJ6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbXJUJ6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbXJUJ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:57:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46096 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXJUJ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:57:56 -0400
Date: Sun, 21 Oct 2007 11:58:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mattia Dongili <malattia@linux.it>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: mysqld prevents s2ram [Re: 2.6.23-mm1]
Message-ID: <20071021095802.GA25669@elf.ucw.cz>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071021055816.GA4204@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021055816.GA4204@inferi.kami.home>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> 
> Ok, now that it boots let's go for more.
> 
> I cannot suspend if mysqld is running. mysql isn't atually doing
> anything useful anyway.

I believe this is known and rafael already has a fix somewhere. The
"guilty" patch already hit mainline, not sure about the "fix" patch.

								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
