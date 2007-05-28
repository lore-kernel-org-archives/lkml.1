Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbXE1Lpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbXE1Lpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbXE1Lp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:45:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47670 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750710AbXE1Lp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:45:26 -0400
Date: Mon, 28 May 2007 13:45:24 +0200
From: Pavel Machek <pavel@suse.cz>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Message-ID: <20070528114524.GE18706@elf.ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <20070527220412.GC22687@srcf.ucam.org> <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl> <20070528111554.GF18807@elf.ucw.cz> <1180351493.4242.31.camel@lov.localdomain> <6BFA837E-47D4-487F-9D71-FA83D6D865E5@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6BFA837E-47D4-487F-9D71-FA83D6D865E5@cam.ac.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This functionality should also be written into the firmware-class  
> (and this fact *is* acknowledged in the sparse documentation).

 Feel free to submit documentation improvements.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
