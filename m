Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbZF2AhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbZF2AhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758470AbZF2Afo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:35:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38675 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758385AbZF2Afm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:35:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A.fNH.4kASKB@chimera>
Subject: [Bug #13319] Page allocation failures with b43 and p54usb
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:30:54 +0200 (CEST)
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
Date		: 2009-04-29 21:01 (61 days old)
References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
		  http://lkml.org/lkml/2009/6/7/136
Handled-By	: Johannes Berg <johannes@sipsolutions.net>


