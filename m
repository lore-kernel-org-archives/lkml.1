Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbYHBTch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbYHBTch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbYHBT2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:28:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758684AbYHBT2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:28:20 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
In-Reply-To: <cbItfVMShGI.A.olC.UMLlIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5ZeQ4vXWqRC.A.gZD.0MLlIB@albercik>
Subject: [Bug #11221] 2.6.27-rc1 oops when plugging USB disk
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  2 Aug 2008 20:04:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed
and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11221
Subject		: 2.6.27-rc1 oops when plugging USB disk
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-08-01 13:35 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121759786223716&w=4


