Return-Path: <linux-kernel-owner+w=401wt.eu-S1765953AbYFGWC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765953AbYFGWC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbYFGVsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759742AbYFGVsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:40 -0400
Cc: "Avi Kivity" <avi@qumranet.com>, "Dave Hansen" <dave@linux.vnet.ibm.com>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.zSC.U2vSIB@albercik>
Subject: [Bug #10863] kvm causing memory corruption?  now 2.6.26-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10863
Subject		: kvm causing memory corruption? now 2.6.26-rc4
Submitter	: Dave Hansen <dave@linux.vnet.ibm.com>
Date		: 2008-06-02 22:30 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121244588705277&amp;w=4
Handled-By	: Avi Kivity <avi@qumranet.com>


