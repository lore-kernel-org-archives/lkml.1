Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbZDQAma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbZDQAma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759700AbZDQAep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:34:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759694AbZDQAeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:34:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Price" <andy@andrewprice.me.uk>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.zGH.Fw85JB@chimera>
Subject: [Bug #13120] BUG: using rootfstype=ext4 causes oops
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13120
Subject		: BUG: using rootfstype=ext4 causes oops
Submitter	: Andrew Price <andy@andrewprice.me.uk>
Date		: 2009-04-15 20:59 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=123982932807371&w=4
Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=123991090816794&w=4


