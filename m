Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbZE3Wmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbZE3Wmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZE3WhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:37:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46562 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbZE3WhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:37:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>, "Woody Suwalski" <woodys@xandros.com>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
In-Reply-To: <4to6E2myxvG.A.muC.aIbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LEcEO2518_I.A.0DD.iIbIKB@chimera>
Subject: [Bug #13406] Kernel does not compile when set to use i915 kernel mode-setting per default
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:37:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13406
Subject		: Kernel does not compile when set to use i915 kernel mode-setting per default
Submitter	: Woody Suwalski <woodys@xandros.com>
Date		: 2009-05-20 19:30 (11 days old)
References	: http://marc.info/?l=linux-acpi&m=124284975803785&w=4
Handled-By	: Len Brown <lenb@kernel.org>
Patch		: http://patchwork.kernel.org/patch/27026/


