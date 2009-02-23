Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZBXAVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZBXAVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZBXATn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:19:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467AbZBXATm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:19:42 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vP9hdyF4fL.A.iMF.GqzoJB@chimera>
Subject: [Bug #12574] possible circular locking dependency detected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 22:48:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12574
Subject		: possible circular locking dependency detected
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2009-01-29 11:35 (26 days old)
References	: http://lkml.org/lkml/2009/2/9/205


