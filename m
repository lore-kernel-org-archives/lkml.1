Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbXEKM3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbXEKM3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbXEKM3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:29:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1350 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756488AbXEKM3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:29:00 -0400
Date: Thu, 10 May 2007 15:33:09 +0000
From: Pavel Machek <pavel@ucw.cz>
To: CIJOML <cijoml@volny.cz>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.de,
       bluez-users@lists.sourceforge.net
Subject: Re: OOPS when swsusp/resume when connected to the internet via BT and GPRS
Message-ID: <20070510153308.GD4052@ucw.cz>
References: <200705070005.33834.cijoml@volny.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705070005.33834.cijoml@volny.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> today I experienced OOPS when connected via BT/GPRS to the internet, then 
> swsup and resumed with dongle in HID proxy mode. Please see details in dmesg 
> log:

I have had similar problems --but never quite repeatable. I believe I
even have patch somewhere, but I was not able to properly test it.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
