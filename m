Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbXGGH6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbXGGH6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 03:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbXGGH62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 03:58:28 -0400
Received: from ip-85-160-88-136.eurotel.cz ([85.160.88.136]:59400 "EHLO
	amd.ucw.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbXGGH62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 03:58:28 -0400
Date: Sat, 7 Jul 2007 09:58:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>, Andi Kleen <ak@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH -mm 1/2] PM: Optional beeping during resume from suspend to RAM
Message-ID: <20070707075832.GD2638@elf.ucw.cz>
References: <200707061549.04952.rjw@sisk.pl> <200707061550.27189.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707061550.27189.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-07-06 15:50:26, Rafael J. Wysocki wrote:
> From: Nigel Cunningham <nigel@nigel.suspend2.net>
> 
> Add a feature allowing the user to make the system beep during a resume from
> suspend to RAM, on x86_64 and i386.
> 
> This is useful for the users with broken resume from RAM, so that they can
> verify if the control reaches the kernel after a wake-up event.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK... (but this should really go in with the second patch in series.)

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
