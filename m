Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZGZXT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZGZXT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZGZXT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:19:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbZGZXT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:19:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alasdair Kergon" <agk@redhat.com>,
       "=?utf-8?q?Christian=20Borntr=C3=A4ger?=" <borntraeger@de.ibm.com>,
       "Mike Snitzer" <snitzer@redhat.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.4TC.OHObKB@chimera>
Subject: [Bug #13834] device mapper fails on some logical volumes
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:28:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13834
Subject		: device mapper fails on some logical volumes
Submitter	: Christian Bornträger <borntraeger@de.ibm.com>
Date		: 2009-07-15 18:52 (12 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=754c5fc7ebb417b23601a6222a6005cc2e7f2913
References	: http://marc.info/?l=linux-kernel&m=124767677206470&w=4
Handled-By	: Mike Snitzer <snitzer@redhat.com>
Patch		: http://patchwork.kernel.org/patch/33534/


