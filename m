Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZDZMkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZDZMkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbZDZMeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:34:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250AbZDZMeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:34:08 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "ACPI Bugzilla" <acpi-bugzilla@lists.sourceforge.net>,
       "Jose Marino" <braket@hotmail.com>, "Len Brown" <len.brown@intel.com>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
In-Reply-To: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <egHshlwQQFE.A.p4C.WpE9JB@chimera>
Subject: [Bug #13032] 2.6.29 regression: network interfaces drop after suspend/resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Apr 2009 11:46:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13032
Subject		: 2.6.29 regression: network interfaces drop after suspend/resume
Submitter	: Jose Marino <braket@hotmail.com>
Date		: 2009-04-07 00:08 (20 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=31878dd86b7df9a147f5e6cc6e07092b4308782b


