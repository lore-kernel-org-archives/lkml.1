Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZE3WkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZE3WkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbZE3Wgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:36:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46531 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbZE3Wge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:36:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "USB" <linux-usb@vger.kernel.org>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
In-Reply-To: <4to6E2myxvG.A.muC.aIbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LEcEO2518_I.A.xsD.1IbIKB@chimera>
Subject: [Bug #13372] Oops in usb-serial with keyspan adapter
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:37:35 +0200 (CEST)
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
Date		: 2009-05-18 0:07 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=124260532924736&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
Patch		: http://patchwork.kernel.org/patch/26603/


