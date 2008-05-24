Return-Path: <linux-kernel-owner+w=401wt.eu-S1763140AbYEXVev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763140AbYEXVev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762566AbYEXVcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:32:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40133 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758750AbYEXVcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:32:50 -0400
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Lukas Hejtmanek" <xhejtman@ics.muni.cz>,
       "Oliver Neukum" <oliver@neukum.org>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A.LYF.TgIOIB@albercik>
Subject: [Bug #10630] USB devices plugged into dock are not discoverred until reload of ehci-hcd
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10630
Subject		: USB devices plugged into dock are not discoverred until reload of ehci-hcd
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-05-05 10:02 (20 days old)
References	: http://lkml.org/lkml/2008/5/5/77
		  http://lkml.org/lkml/2008/5/19/44
Handled-By	: Oliver Neukum <oliver@neukum.org>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: http://lkml.org/lkml/2008/5/20/285


