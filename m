Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZGCCSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZGCCSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757639AbZGCCSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:18:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:41783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757610AbZGCCSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:18:08 -0400
Subject: Reminder for feature ACPI procfs interface removal date July 2008
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 07:39:53 +0530
Message-Id: <1246586993.2530.11.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Len and Zhang,

What:   ACPI procfs interface
When:   July 2008
Why:    ACPI sysfs conversion should be finished by January 2008.
        ACPI procfs interface will be removed in July 2008 so that
        there is enough time for the user space to catch up.
Who:    Zhang Rui <rui.zhang@intel.com>

---------------------------

What:   /proc/acpi/button
When:   August 2007
Why:    /proc/acpi/button has been replaced by events to the input layer
        since 2.6.20.
Who:    Len Brown <len.brown@intel.com>

---------------------------

What:   /proc/acpi/event
When:   February 2008
Why:    /proc/acpi/event has been replaced by events via the input layer
        and netlink since 2.6.23.
Who:    Len Brown <len.brown@intel.com>

If you are facing any issue regarding feature removal kindly update the
"Documentation/feature-removal-schedule.txt" like what you are waiting
for.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/

