Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYKVWZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYKVWZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYKVWZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:25:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYKVWZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:25:30 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Len Brown" <len.brown@intel.com>, "Lin Ming" <ming.m.lin@intel.com>,
       "Robert Moore" <Robert.Moore@intel.com>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.elE.t9HKJB@chimera>
Subject: [Bug #11822] ACPI Warning (nspredef-0858): _SB_.PCI0.LPC_.EC__.BAT0._BIF: Return Package type mismatch at index 9 - found Buffer, expected String [20080926]
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:24:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11822
Subject		: ACPI Warning (nspredef-0858): _SB_.PCI0.LPC_.EC__.BAT0._BIF: Return Package type mismatch at index 9 - found Buffer, expected String [20080926]
Submitter	: Len Brown <len.brown@intel.com>
Date		: 2008-10-25 01:26 (29 days old)
Handled-By	: Robert Moore <Robert.Moore@intel.com>
		  Lin Ming <ming.m.lin@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18949&action=view


