Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYH3Vfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYH3Vfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbYH3VZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:25:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58221 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025AbYH3VZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:25:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>, "jurriaan" <thunder7@xs4all.nl>,
       "Neil Brown" <neilb@suse.de>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.IxD._hbuIB@albercik>
Subject: [Bug #11441] lots of 'in_atomic():1, irqs_disabled():0' with software-raid1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11441
Subject		: lots of 'in_atomic():1, irqs_disabled():0' with software-raid1
Submitter	: jurriaan <thunder7@xs4all.nl>
Date		: 2008-08-27 17:05 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121985847724696&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
		  Neil Brown <neilb@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=121998896602338&w=4


