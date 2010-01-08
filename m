Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937Ab0AHQhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0AHQhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921Ab0AHQhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:37:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58769 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab0AHQhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:37:22 -0500
Date: Fri, 8 Jan 2010 17:36:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, jayakumar.lkml@gmail.com,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
Message-ID: <20100108163655.GA8328@elf.ucw.cz>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
 <20100108083020.GB3696@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108083020.GB3696@core.coreip.homeip.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
> 
> What this attribute is for?

Actually, all the new files this added need to be documented.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
