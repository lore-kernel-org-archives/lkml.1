Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYLJTYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYLJTYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYLJTYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:24:42 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:62669 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbYLJTYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:24:41 -0500
Date: Wed, 10 Dec 2008 14:24:21 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: ACPI bugs - Dec-2008 status report
X-X-Sender: lenb@localhost.localdomain
To: linux-acpi@vger.kernel.org
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0812101350260.3211@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to thank the bug submitters, testers, debuggers,
and developers who worked together to significantly improve
the quality of ACPI in Linux this year.  The numbers
below are something you should all be proud of.

ACPI bugs filed at bugzilla.kernel.org
--------------------------------------
1807 submitted total (1/day over 5 years)
49 unresolved (was 115 in Dec-2007)

http://userweb.kernel.org/~lenb/20081210-bugzilla-history.gif

Unresolved bugs per ACPI sub-category:

http://userweb.kernel.org/~lenb/20081210-bugzilla-histogram.gif

9 EC
9 Power-Sleep-Wake
6 Config-Interrupts
5 Power-Processor
4 Platform-drivers
3 Power-Thermal
3 Power-Video
2 Config-Hotplug
2 Power-off
2 Other
2 BIOS
1 Config-Processors
1 Config-Other
0 Config-Tables
0 ACPICA-Core
0 Power-Battery
0 Power-Fan
0 Power-Other

ACPICA bugs filed at http://acpica.org/bugzilla
-----------------------------------------------
24 unresolved (was 85 in Jan-2008)

Suspend/Resume bugs at bugzilla.kernel.org
------------------------------------------
35 unresolved (102 filed, was 44 unresolved as recently as Sep-2008)

thanks,
-- 
Len Brown, Intel Open Source Technology Center
