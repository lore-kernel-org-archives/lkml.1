Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbYILU7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbYILU7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbYILUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:46:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42918 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758152AbYILUqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:46:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.OiF.mbsyIB@albercik>
Subject: [Bug #11556] e100: PCI wake-up handling rework causes "Error clearing wake event"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11556
Subject		: e100: PCI wake-up handling rework causes "Error clearing wake event"
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-09-09 6:12 (4 days old)
References	: http://marc.info/?l=linux-netdev&m=122094080712131&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-kernel&m=122096638020191&w=4


