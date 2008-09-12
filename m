Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbYILUzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbYILUzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbYILUp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:45:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758574AbYILUp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:45:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Frans Pop" <elendil@planet.nl>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.cjG.IcsyIB@albercik>
Subject: [Bug #11507] usb: sometimes dead keyboard after boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11507
Subject		: usb: sometimes dead keyboard after boot
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-26 21:03 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121977815018224&w=2
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
Patch		: http://www.spinics.net/lists/linux-usb/msg09735.html


