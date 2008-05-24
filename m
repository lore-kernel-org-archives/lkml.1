Return-Path: <linux-kernel-owner+w=401wt.eu-S1763409AbYEXVg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763409AbYEXVg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761769AbYEXVc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:32:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761793AbYEXVc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:32:57 -0400
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Karol Lewandowski" <lmctlx@gmail.com>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A.1mE.cfIOIB@albercik>
Subject: [Bug #10670] BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:39 +0200 (CEST)
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
Date		: 2008-05-08 23:12 (17 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
		  http://lkml.org/lkml/2008/5/12/12
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16153&amp;action=view


