Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZL2PSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZL2PSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZL2PSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:18:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38925 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbZL2PN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:13:56 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dominik Brodowski" <linux@dominikbrodowski.net>,
       "Jeff Garzik" <jeff@garzik.org>, "Pavel Machek" <pavel@ucw.cz>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.6eH.WnhOLB@chimera>
Subject: [Bug #14908] 256MB CF card no longer recognized in PCMCIA slot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:09:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14908
Subject		: 256MB CF card no longer recognized in PCMCIA slot
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-12-19 21:55 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=126125973632173&w=4
Handled-By	: Dominik Brodowski <linux@dominikbrodowski.net>


