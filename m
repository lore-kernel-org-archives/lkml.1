Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbYILUwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbYILUwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbYILUpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:45:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42825 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758369AbYILUpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:45:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Oliver Neukum" <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.4eH.4csyIB@albercik>
Subject: [Bug #11442] btusb hibernation/suspend breakage in current -git
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11442
Subject		: btusb hibernation/suspend breakage in current -git
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-08-25 11:37 (19 days old)
References	: http://marc.info/?l=linux-bluetooth&m=121966402012074&w=4
Handled-By	: Oliver Neukum <oliver@neukum.org>
Patch		: http://marc.info/?l=linux-bluetooth&m=121967226027323&w=4


