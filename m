Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZAVVb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZAVVb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZAVVbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:31:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33868 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbZAVVbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:31:50 -0500
Date: Thu, 22 Jan 2009 22:31:39 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: HP accelerometer driver: testers wanted
Message-ID: <20090122213139.GD2159@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



HP accelerometer driver: testers wanted
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is in latest -mm. Enable CONFIG_SENSORS_LIS3LV02D,
recompile/reboot. Documentation is in Documentation/hwmon/lis3lv02d
and Documentation/hwmon/hpfall.c is standalone binary that should park
your disk (and light a led) as soon as freefall is detected.

For standalone patch, see

	http://www.livejournal.com/~pavelmachek


								Pavel
-- 
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
