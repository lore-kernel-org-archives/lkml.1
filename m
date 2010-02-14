Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0BOABe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:01:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab0BNX6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:58:31 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Jody Bruchon" <jody@nctritech.com>, "Takashi Iwai" <tiwai@suse.de>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
In-Reply-To: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4un6Gst5rKB.A.TVH.1iIeLB@chimera>
Subject: [Bug #15244] PROBLEM: hda-intel divide by zero kernel crash in azx_position_ok()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Feb 2010 00:38:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15244
Subject		: PROBLEM: hda-intel divide by zero kernel crash in azx_position_ok()
Submitter	: Jody Bruchon <jody@nctritech.com>
Date		: 2010-02-06 0:32 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=126541276028173&w=2
Handled-By	: Takashi Iwai <tiwai@suse.de>
		  Jody Bruchon <jody@nctritech.com>


