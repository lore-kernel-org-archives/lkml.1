Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZJKW0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZJKW0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZJKWZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:25:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbZJKWZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:25:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <r-4Wjt4coy.A.GnD.qal0KB@chimera>
Subject: [Bug #14352] WARNING: at net/mac80211/scan.c:267
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 00:22:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14352
Subject		: WARNING: at net/mac80211/scan.c:267
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-10-08 00:30 (4 days old)
References	: http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089#c7


