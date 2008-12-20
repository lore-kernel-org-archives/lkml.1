Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYLUAMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYLUAMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbYLUAK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:10:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49903 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbYLUAKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:10:24 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <lenb@kernel.org>, "Len Brown" <len.brown@intel.com>
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
In-Reply-To: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vy-yJy0f3YP.A.oX.KaYTJB@chimera>
Subject: [Bug #12252] new oops on resume due to ACPI_PREEMPTION_POINT()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 20 Dec 2008 23:00:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12252
Subject		: new oops on resume due to ACPI_PREEMPTION_POINT()
Submitter	: Len Brown <len.brown@intel.com>
Date		: 2008-12-18 18:17 (3 days old)
Handled-By	: Len Brown <lenb@kernel.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=19370&action=view


