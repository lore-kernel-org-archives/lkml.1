Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbYGFNIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbYGFNIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYGFNBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:01:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786AbYGFNBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:02 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "Tejun Heo" <htejun@gmail.com>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.SiC.A1LcIB@albercik>
Subject: [Bug #10860] total system freeze at boot with 2.6.26-rc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10860
Subject		: total system freeze at boot with 2.6.26-rc
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-06-05 12:38 (32 days old)
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16556


