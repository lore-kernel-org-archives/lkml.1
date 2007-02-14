Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXBNM7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXBNM7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932246AbXBNM7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:59:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35049 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932242AbXBNM7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:59:08 -0500
Date: Wed, 14 Feb 2007 13:58:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
Message-ID: <20070214125849.GH22008@elf.ucw.cz>
References: <200702071418.51058.lenb@kernel.org> <20070209230928.GD3949@ucw.cz> <20070210015836.GA24082@khazad-dum.debian.net> <20070211193517.GA15445@elf.ucw.cz> <20070211194851.GB26874@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211194851.GB26874@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Not including another /proc/acpi/ibm -like nightmare, is it?
> > > 
> > > Don't worry, I am already on my way to kill /proc/acpi/ibm... :-)
> > 
> > Great, thanks!
> > 								Pavel
> 
> None of the platform/hwmon/led driver model code landed there yet, but it
> should be available at:
> 
> http://repo.or.cz/w/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git queue/waiting
> 
> eventually.  Note, I push a lot to that branch, and it is a stgit head, so
> it gets rewond if a change that makes sense in an earlier patch shows up.

Great... if you want some testing, just mail me patch against mainline
or whatever... (I don't think I can handle stgit).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
