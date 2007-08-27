Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbXH0MIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbXH0MIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXH0MHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:07:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47630 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751099AbXH0MHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:07:47 -0400
Date: Mon, 27 Aug 2007 12:43:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: cpu hotplug support broken in 2.6.23-rc3
Message-ID: <20070827104350.GA2073@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Trying to do few onlines/offlines reliably hangs my machine (thinkpad
x60, i386 architecture).

Plus I guess it would be nice to add CPU HOTPLUG into MAINTAINERS
file:

pavel@amd:/data/l/linux$ grep CPU MAINTAINERS
CPU FREQUENCY DRIVERS
CPUID/MSR DRIVER
CPUSETS
i386 SETUP CODE / CPU ERRATA WORKAROUNDS
SCx200 CPU SUPPORT
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
