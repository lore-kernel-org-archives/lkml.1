Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbYBGVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbYBGVrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYBGVq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:46:59 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58977 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755167AbYBGVq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:46:58 -0500
Date: Thu, 7 Feb 2008 22:47:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Len Brown <len.brown@intel.com>
Subject: ACPI_WMI: worst config description of all times
Message-ID: <20080207214715.GA15211@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



See? It even has completely useless help text.

Does WMI stand for Windows Management Instrumentation? It is some
server management feature? What is it good for?

								Pavel

  WMI (EXPERIMENTAL) (ACPI_WMI) [N/m/y/?] (NEW) ?

This driver adds support for the ACPI-WMI mapper device (PNP0C14)
found on some systems.

NOTE: You will need another driver or userspace application on top of
this to actually use anything defined in the ACPI-WMI mapper.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
