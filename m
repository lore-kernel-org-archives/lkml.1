Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbZEXWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbZEXWPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759150AbZEXWJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:09:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188AbZEXWJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:09:26 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uSztiUhmDDC.A.E3H.U9bGKB@chimera>
Subject: [Bug #13372] Oops in usb-serial with keyspan adapter
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:11:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13372
Subject		: Oops in usb-serial with keyspan adapter
Submitter	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date		: 2009-05-18 0:07 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=124260532924736&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


