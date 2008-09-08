Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYIHPVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYIHPVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYIHPVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:21:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47921 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYIHPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:21:16 -0400
Date: Mon, 8 Sep 2008 17:10:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Controlling backlight on thinkpad x60
Message-ID: <20080908151058.GA1650@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Some time ago, FN-Home/End just adjusted the brightness, and
/proc/acpi/ibm contained backlight control.

In 2.6.27-rc5, /proc/acpi/ibm does not contain backlight control and
/sys/class/backlight is empty...

(I do have CONFIG_ACPI_VIDEO disabled, it killed my machine last time
I enabled it, is it mandatory now?)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
