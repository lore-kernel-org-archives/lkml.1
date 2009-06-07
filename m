Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZFGNIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZFGNIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbZFGNHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:07:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757838AbZFGNG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:06:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Niel Lambrechts" <niel.lambrechts@gmail.com>,
       "Tejun Heo" <htejun@gmail.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
In-Reply-To: <sIiXQlfwS3D.A.81.dj7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AN6kEAA5GQ.A.5XC.tk7KKB@chimera>
Subject: [Bug #13017] ATA bus errors on resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 12:06:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13017
Subject		: ATA bus errors on resume
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-03-25 5:19 (75 days old)
References	: http://marc.info/?l=linux-kernel&m=123795841615989&w=4
Handled-By	: Tejun Heo <htejun@gmail.com>


