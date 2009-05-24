Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbZEXWOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbZEXWOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759038AbZEXWJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:09:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34246 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758918AbZEXWJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:09:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jonathan Corbet" <corbet@lwn.net>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uSztiUhmDDC.A.vW.p9bGKB@chimera>
Subject: [Bug #13325] 2.6.30-rc kills my box hard - and lockdep chains
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:11:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13325
Subject		: 2.6.30-rc kills my box hard - and lockdep chains
Submitter	: Jonathan Corbet <corbet@lwn.net>
Date		: 2009-05-14 15:49 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=124231630701394&w=4


