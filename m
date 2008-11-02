Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYKBSDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYKBSDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYKBSBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:01:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35637 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbYKBSBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:01:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Jens Axboe" <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Tomas Winkler" <tomasw@gmail.com>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
In-Reply-To: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wOAXuecskPD.A.3LH.0keDJB@chimera>
Subject: [Bug #11845] Suspend regression on Lenovo x60
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:07:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11845
Subject		: Suspend regression on Lenovo x60
Submitter	: Jens Axboe <jens.axboe@oracle.com>
Date		: 2008-10-24 18:02 (10 days old)
References	: http://marc.info/?l=linux-next&m=122487159829507&w=4
		  http://marc.info/?l=linux-kernel&m=122512449714310&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Tomas Winkler <tomasw@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=122513311900482&w=4
		  http://marc.info/?l=linux-wireless&m=122518625308673&w=4


