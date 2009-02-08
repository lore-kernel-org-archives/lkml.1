Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZBHWAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZBHWAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZBHVt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:49:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbZBHVt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:49:57 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brian Gerst" <brgerst@gmail.com>, "Jiri Slaby" <jirislaby@gmail.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.XNE.Q20jJB@chimera>
Subject: [Bug #12663] Commit 8c7e58e690ae60ab4215b025f433ed4af261e103 breaks resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12663
Subject		: Commit 8c7e58e690ae60ab4215b025f433ed4af261e103 breaks resume
Submitter	: Jiri Slaby <jirislaby@gmail.com>
Date		: 2009-02-07 18:40 (2 days old)
References	: http://lkml.org/lkml/2009/2/7/100
Handled-By	: Brian Gerst <brgerst@gmail.com>
Patch		: http://lkml.org/lkml/2009/2/7/100
		  http://lkml.org/lkml/2009/2/8/59


