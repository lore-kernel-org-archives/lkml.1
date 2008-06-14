Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYFNV2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYFNV2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbYFNVUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:20:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbYFNVUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:20:16 -0400
Cc: "Ingo Molnar" <mingo@elte.hu>,
       =?utf-8?q?N=C3=A9meth=20M=C3=A1rton?= <nm127@freemail.hu>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.UoD.BJDVIB@albercik>
Subject: [Bug 10864] [regression][bisected] ~90,000 wakeups as of 2.6.26-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10864
Subject		: [regression][bisected] ~90,000 wakeups as of 2.6.26-rc3
Submitter	: Németh Márton <nm127@freemail.hu>
Date		: 2008-06-03 5:18 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121247101601790&w=4


