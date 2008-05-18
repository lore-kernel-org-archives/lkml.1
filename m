Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbYERMPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbYERMPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758824AbYERMNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:13:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758782AbYERMNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:13:14 -0400
Cc: "Dan Williams" <dan.j.williams@intel.com>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Jeff Garzik" <jeff@garzik.org>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
In-Reply-To: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7wuznNhcUqC.A.ItB.2tBMIB@albercik>
Subject: [Bug #10622] [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 18 May 2008 13:13:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10622
Subject		: [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Submitter	: Jeff Garzik <jeff@garzik.org>
Date		: 2008-05-04 07:22 (15 days old)
References	: http://lkml.org/lkml/2008/5/4/76
Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
		  Dan Williams <dan.j.williams@intel.com>


