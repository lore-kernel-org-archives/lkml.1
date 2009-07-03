Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZGCCSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZGCCSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757565AbZGCCSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:18:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:41779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238AbZGCCSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:18:01 -0400
Subject: Reminder for feature dev->power.power_state removal date July 2007
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Pavel Machek <pavel@ucw.cz>, linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 07:36:48 +0530
Message-Id: <1246586808.2530.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pavel,

What:   dev->power.power_state
When:   July 2007
Why:    Broken design for runtime control over driver power states, confusing
        driver-internal runtime power management with:  mechanisms to support
        system-wide sleep state transitions; event codes that distinguish
        different phases of swsusp "sleep" transitions; and userspace policy
        inputs.  This framework was never widely used, and most attempts to
        use it were broken.  Drivers should instead be exposing domain-specific
        interfaces either to kernel or to userspace.
Who:    Pavel Machek <pavel@suse.cz>

If you are facing any issue regarding feature removal kindly update the
"Documentation/feature-removal-schedule.txt" like what you are waiting
for.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/

