Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYIFXMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYIFXMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYIFXHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:07:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37845 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbYIFXHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:07:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christopher Li" <chrisl@vmware.com>,
       "David Vrabel" <david.vrabel@csr.com>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
In-Reply-To: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Wz8EH5sroeE.A.KbB.wpwwIB@albercik>
Subject: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  6 Sep 2008 23:30:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11382
Subject		: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Submitter	: David Vrabel <david.vrabel@csr.com>
Date		: 2008-08-08 10:47 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=121819267211679&w=4
Handled-By	: Christopher Li <chrisl@vmware.com>
Patch		: http://marc.info/?l=linux-mm-commits&m=122038324200305&w=4


