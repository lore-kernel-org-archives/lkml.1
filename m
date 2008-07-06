Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYGFNFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYGFNFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbYGFNBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:01:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982AbYGFNBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel Vetter" <daniel@ffwll.ch>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.tYB.pzLcIB@albercik>
Subject: [Bug #10989] kernel oopses when wiggling the mouse to make it known to hidd
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10989
Subject		: kernel oopses when wiggling the mouse to make it known to hidd
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2008-06-26 10:32 (11 days old)


