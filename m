Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYINKRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYINKRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 06:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYINKRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 06:17:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48878 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYINKRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 06:17:13 -0400
Date: Sun, 14 Sep 2008 12:18:39 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11557] Controlling backlight on thinkpad x60
Message-ID: <20080914101838.GA1681@elf.ucw.cz>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.UcF.jbsyIB@albercik> <20080913151330.GA20761@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080913151330.GA20761@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-09-13 16:13:30, Matthew Garrett wrote:
> I don't think this is a regression. The correct way to drive this 
> hardware has always been through the ACPI video driver. The fact that 
> thinkpad-acpi would also attempt to drive it was a bug.

I'm pretty sure thinkpad-acpi is older then ACPI-video. So yes, I
believe this is a regression, but it may be pretty old one.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
