Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbZHBWBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbZHBWBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZHBWBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:01:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38011 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbZHBWA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:00:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Rientjes" <rientjes@google.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
In-Reply-To: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7ixSg7D88bK.A.dYH.LsgdKB@chimera>
Subject: [Bug #13319] Page allocation failures with b43 and p54usb
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 21:09:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
Subject		: Page allocation failures with b43 and p54usb
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2009-04-29 21:01 (96 days old)
References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
		  http://lkml.org/lkml/2009/6/7/136
		  http://lkml.org/lkml/2009/7/26/213
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
		  David Rientjes <rientjes@google.com>
Patch		: http://patchwork.kernel.org/patch/37655/


