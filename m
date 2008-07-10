Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYGJPE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYGJPE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbYGJPEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:04:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44431 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302AbYGJPED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:04:03 -0400
Date: Thu, 10 Jul 2008 13:37:07 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -mm 8/8] ACPI PM: Add DMI quirk list for ACPI 1.0
	suspend ordering
Message-ID: <20080710113707.GG15412@elf.ucw.cz>
References: <200807100152.17755.rjw@sisk.pl> <200807100207.03636.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807100207.03636.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-07-10 02:07:02, Rafael J. Wysocki wrote:
> From: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Subject: ACPI PM: Add DMI quirk list for ACPI 1.0 suspend ordering
> 
> There are a few BIOS' that we know of already that need to use the
> ACPI 1.0 suspend order. This appears to be only be a small minority of
> mostly nVidia based systems.
> 
> Based on observation of Windows behaviour, it's clear that Windows is
> also doing maintaining its own list of broken hardware that needs this
> workaround.
> 
> Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
