Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZL2Plj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZL2Plj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZL2Pl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:41:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39262 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbZL2PeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:34:05 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Antti=20Kaijanm=C3=A4ki?=" <antti@kaijanmaki.net>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.29C.AxhOLB@chimera>
Subject: [Bug #14743] New rtl8187 rfkill support prevents using wlan completely.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14743
Subject		: New rtl8187 rfkill support prevents using wlan completely.
Submitter	: Antti Kaijanmäki <antti@kaijanmaki.net>
Date		: 2009-12-05 20:10 (25 days old)


