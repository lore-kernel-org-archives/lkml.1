Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZBNXOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZBNXOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbZBNXHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:07:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbZBNXHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:07:24 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brian Gerst" <brgerst@gmail.com>, "Jiri Slaby" <jirislaby@gmail.com>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rjPbZ5GRJPO.A.kME.jr0lJB@chimera>
Subject: [Bug #12663] Commit 8c7e58e690ae60ab4215b025f433ed4af261e103 breaks resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:38:21 +0100 (CET)
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
Date		: 2009-02-07 18:40 (8 days old)
References	: http://lkml.org/lkml/2009/2/7/100
Handled-By	: Brian Gerst <brgerst@gmail.com>
Patch		: http://lkml.org/lkml/2009/2/7/100
		  http://lkml.org/lkml/2009/2/8/59


