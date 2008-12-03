Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbYLDALs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbYLDALs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbYLDADf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:03:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48489 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbYLDADc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:03:32 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.VLH.xoxNJB@chimera>
Subject: [Bug #12156] v2.6.28-rc2: x86_32 relocation regression?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:58:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12156
Subject		: v2.6.28-rc2: x86_32 relocation regression?
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-11-24 21:19 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=122756158220966&w=4


