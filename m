Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbZEPWYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbZEPWYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZEPWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:16:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43909 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758194AbZEPWQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:16:17 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Ozan=20=C3=87a=C4=9Flayan?=" <ozan@pardus.org.tr>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.axH.ZYzDKB@chimera>
Subject: [Bug #13326] Null pointer dereference in rtc-cmos driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13326
Subject		: Null pointer dereference in rtc-cmos driver
Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
Date		: 2009-05-14 16:16 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=124231783704696&w=4


