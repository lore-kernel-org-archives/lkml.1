Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYKPSof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYKPSof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbYKPSfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:35:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43030 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbYKPSfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:35:41 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Andi Kleen" <andi@firstfloor.org>, "Jiri Kosina" <jkosina@suse.cz>,
       "Jiri Slaby" <jirislaby@gmail.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.29D.FAGIJB@chimera>
Subject: [Bug #12042] USB hid blocks USB port in 2.6.28rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12042
Subject		: USB hid blocks USB port in 2.6.28rc3
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-11-11 0:31 (6 days old)
References	: http://marc.info/?l=linux-usb&m=122636246522848&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  Jiri Slaby <jirislaby@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=122661425620251&w=2


