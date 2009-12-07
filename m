Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZLGBQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZLGBQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 20:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758541AbZLGBQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 20:16:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:41418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbZLGBQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 20:16:14 -0500
Date: Sun, 6 Dec 2009 16:55:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091206165551.2529075f@infradead.org>
In-Reply-To: <7AB497C7-8495-4535-9E83-81307E008BF4@gmail.com>
References: <200912052216.19540.rjw@sisk.pl>
	<200912060055.36130.rjw@sisk.pl>
	<alpine.LFD.2.00.0912051635330.3560@localhost.localdomain>
	<200912060254.10081.rjw@sisk.pl>
	<alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
	<20091206113555.5a646713@infradead.org>
	<alpine.LFD.2.00.0912061144100.3560@localhost.localdomain>
	<20091206121803.70385c33@infradead.org>
	<7AB497C7-8495-4535-9E83-81307E008BF4@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009 14:54:48 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > isn't serio the PS/2 stuff?
> 
> Yes, that's your PS/2 mouse (rather touchpad) and the delay comes
> from device reset (needed by some keyboard controllers - I remember
> HP -or it and keyboard will be dead at resume).

and I have a HP laptop... so this makes perfect sense.
Thanks for the explenation!

Now, the good news is that serio is near invisible on resume...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
