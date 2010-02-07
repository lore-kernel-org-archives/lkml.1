Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab0BGWsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:48:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932945Ab0BGWq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:46:28 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Johannes Hirte" <johannes.hirte@fem.tu-ilmenau.de>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
In-Reply-To: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <445R0ey9hAI.A.Ri.HozbLB@chimera>
Subject: [Bug #15246] BUG: Bad page state in process portageq
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Feb 2010 23:28:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15246
Subject		: BUG: Bad page state in process portageq
Submitter	: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Date		: 2010-02-07 0:45 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=126550356515887&w=2


