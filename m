Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZKPWyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZKPWyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZKPWx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:53:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60261 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbZKPWxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:53:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Artem S. Tashkinov" <t.artem@mailcity.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.XZG.ATdALB@chimera>
Subject: [Bug #14616] [2.6.32 regression] sata_nv: commit 6489e3262e6b188a1a009b65e8a94b7aa17645b7 slows down system boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14616
Subject		: [2.6.32 regression] sata_nv: commit 6489e3262e6b188a1a009b65e8a94b7aa17645b7 slows down system boot
Submitter	: Artem S. Tashkinov <t.artem@mailcity.com>
Date		: 2009-11-16 19:49 (1 days old)


