Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbYFGVuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbYFGVuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758121AbYFGVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbYFGVs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:26 -0400
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Karol Lewandowski" <lmctlx@gmail.com>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.M9E.A5vSIB@albercik>
Subject: [Bug #10670] BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
Submitter	: Karol Lewandowski <lmctlx@gmail.com>
Date		: 2008-05-08 23:12 (31 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
		  http://lkml.org/lkml/2008/5/12/12
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16153&amp;action=view


