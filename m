Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbZDFV7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbZDFV7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760027AbZDFVv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:51:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49952 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760015AbZDFVv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:51:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Niel Lambrechts" <niel.lambrechts@gmail.com>,
       "Tejun Heo" <htejun@gmail.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AsKNxFx2juN.A.mWH.2Fn2JB@chimera>
Subject: [Bug #13017] ATA bus errors on resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  6 Apr 2009 21:05:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13017
Subject		: ATA bus errors on resume
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-03-25 5:19 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=123795841615989&w=4
Handled-By	: Tejun Heo <htejun@gmail.com>


