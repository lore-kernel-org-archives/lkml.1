Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZKPWxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZKPWxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbZKPWxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:53:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbZKPWxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:53:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Yong Zhang" <yong.zhang0@gmail.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.T9G.RTdALB@chimera>
Subject: [Bug #14481] umount blocked for more than 120 seconds after USB drive removal
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14481
Subject		: umount blocked for more than 120 seconds after USB drive removal
Submitter	: Robert Hancock <hancockrwd@gmail.com>
Date		: 2009-10-21 5:26 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=125610280532245&w=4


