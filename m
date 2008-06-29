Return-Path: <linux-kernel-owner+w=401wt.eu-S1763227AbYF2Tla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763227AbYF2Tla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760135AbYF2Tbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759696AbYF2Tba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:30 -0400
Cc: "Greg Kroah-Hartman" <greg@kroah.com>,
       "Helge Hafting" <helge.hafting@aitel.hist.no>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.UaD.y69ZIB@albercik>
Subject: [Bug #10962] 2.6.26-rc2 WARNING from usb-serial, and then my gps is dead
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10962
Subject		: 2.6.26-rc2 WARNING from usb-serial, and then my gps is dead
Submitter	: Helge Hafting <helge.hafting@aitel.hist.no>
Date		: 2008-06-22 18:22 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121415899320685&w=4
Handled-By	: Greg Kroah-Hartman <greg@kroah.com>


