Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbZEPWWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbZEPWWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbZEPWPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:15:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43895 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968AbZEPWPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:15:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Corey Minyard" <minyard@acm.org>, "Ferenc Wagner" <wferi@niif.hu>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.gn.pYzDKB@chimera>
Subject: [Bug #13298] modprobe ipmi_si hangs under 2.6.30-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13298
Subject		: modprobe ipmi_si hangs under 2.6.30-rc5
Submitter	: Ferenc Wagner <wferi@niif.hu>
Date		: 2009-05-12 21:28 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124216379407177&w=4


