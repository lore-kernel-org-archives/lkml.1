Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZL2PPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZL2PPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZL2POl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:14:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbZL2POf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:14:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Sergei Trofimovich" <slyich@gmail.com>, "Takashi Iwai" <tiwai@suse.de>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.wuG.KnhOLB@chimera>
Subject: [Bug #14935] hd-audio0 eats 25% CPU (according to top)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:10:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14935
Subject		: hd-audio0 eats 25% CPU (according to top)
Submitter	: Sergei Trofimovich <slyich@gmail.com>
Date		: 2009-12-25 10:21 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=126173644210280&w=4
Handled-By	: Takashi Iwai <tiwai@suse.de>
Patch		: http://patchwork.kernel.org/patch/69747/


