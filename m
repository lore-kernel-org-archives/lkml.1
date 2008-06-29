Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbYF2Th6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbYF2Th6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbYF2Tbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbYF2Tb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:27 -0400
Cc: "Dionisus Torimens" <djtm@gmx.net>, "Pavel Machek" <pavel@suse.cz>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.WYE.b79ZIB@albercik>
Subject: [Bug #10923] System turns off during wake from S3, Wake Regression from 2.6.25 (SMP related)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10923
Subject		: System turns off during wake from S3, Wake Regression from 2.6.25 (SMP related)
Submitter	: Dionisus Torimens <djtm@gmx.net>
Date		: 2008-06-15 16:24 (15 days old)


