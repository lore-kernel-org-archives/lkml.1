Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbZF2Aje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbZF2Aje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758634AbZF2Af4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:35:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582AbZF2Afu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:35:50 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Francis Moreau" <francis.moro@gmail.com>,
       "netdev" <netdev@vger.kernel.org>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A.JGH.tkASKB@chimera>
Subject: [Bug #13328] b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:30:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13328
Subject		: b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
Submitter	: Francis Moreau <francis.moro@gmail.com>
Date		: 2009-05-03 16:22 (57 days old)
References	: http://marc.info/?l=linux-kernel&m=124136778012280&w=4


