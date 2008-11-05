Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYKEKWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYKEKWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYKEKWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:22:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45765 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754164AbYKEKWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:22:16 -0500
Date: Wed, 5 Nov 2008 10:54:50 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.28 regression? LCD display inactive after reboot on
	Toshiba Portege 4000
Message-ID: <20081105095450.GA1424@ucw.cz>
References: <200811031600.59968.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811031600.59968.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-11-03 16:00:59, Andrey Borzenkov wrote:
> I had this every now and then before but right now I consistently
> have the issue after reboot under 2.6.28-rc2 and emergency reboot
> (SysRq-B) under rc3 (emergency because I cannot get past creating
> devices in initrd - it just hangs there).
> 
> After reboot display is empty; I have to use hot key (Fn-F5 in this
> case to reactivate LCD again).

Report it to toshiba / ask for updated bios?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
