Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbZJAXMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbZJAXMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZJAXL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:11:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbZJAXL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:11:57 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Dumazet" <eric.dumazet@gmail.com>,
       "Ralf Hildebrandt" <Ralf.Hildebrandt@charite.de>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.mdH.sMTxKB@chimera>
Subject: [Bug #14301] WARNING: at net/ipv4/af_inet.c:154
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:56:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14301
Subject		: WARNING: at net/ipv4/af_inet.c:154
Submitter	: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Date		: 2009-09-30 12:24 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125431350218137&w=4


