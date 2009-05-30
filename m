Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZE3W4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZE3W4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbZE3Wx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:53:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46774 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636AbZE3Wxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:53:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Niel Lambrechts" <niel.lambrechts@gmail.com>,
       "Tejun Heo" <htejun@gmail.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.QEH.SWbIKB@chimera>
Subject: [Bug #13017] ATA bus errors on resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13017
Subject		: ATA bus errors on resume
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-03-25 5:19 (67 days old)
References	: http://marc.info/?l=linux-kernel&m=123795841615989&w=4
Handled-By	: Tejun Heo <htejun@gmail.com>


