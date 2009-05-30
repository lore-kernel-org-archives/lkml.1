Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbZE3Wh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbZE3Wh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZE3Wfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:35:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46489 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbZE3Wfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:35:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
In-Reply-To: <4to6E2myxvG.A.muC.aIbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LEcEO2518_I.A.zTE.aJbIKB@chimera>
Subject: [Bug #13319] Page allocation failures with b43 and p54usb
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:37:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
Subject		: Page allocation failures with b43 and p54usb
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2009-04-29 21:01 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
Handled-By	: Johannes Berg <johannes@sipsolutions.net>


