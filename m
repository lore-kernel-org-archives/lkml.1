Return-Path: <linux-kernel-owner+w=401wt.eu-S1765450AbYFGV6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765450AbYFGV6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760251AbYFGVsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145AbYFGVsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:35 -0400
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Oliver Neukum" <oliver@neukum.org>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.SAD.x2vSIB@albercik>
Subject: [Bug #10825] appletouch after wakeup
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10825
Subject		: appletouch after wakeup
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-27 3:29 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121185900618047&amp;w=4
		  http://lkml.org/lkml/2008/5/31/193
		  http://lkml.org/lkml/2008/5/31/193
Handled-By	: Oliver Neukum <oliver@neukum.org>


