Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYIQLp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYIQLp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 07:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYIQLpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 07:45:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56314 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYIQLpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 07:45:49 -0400
Date: Wed, 17 Sep 2008 12:18:09 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI "Soft-off" power button only rebooting system, not
	powering off
Message-ID: <20080917101809.GA4771@elf.ucw.cz>
References: <76366b180809162150o51701a1fk209af4e84ffc5674@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76366b180809162150o51701a1fk209af4e84ffc5674@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-09-17 00:50:03, Andrew Paprocki wrote:
> I have an AMD / Award BIOS based system which does not properly shut
> off when I hold down the power button for 4 seconds. The BIOS is
> configured to have "Soft-off" set to "Delay for 4 seconds" which is
> supposed to power the machine off if the button is held that long.
> 
> I first thought this could be a BIOS bug, but this *only* appears to
> happen while Linux is running. If the computer is running WinXP, it

Well, so the BIOS is broken. 4second hold should power down the
machine regardless of the operating system.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
