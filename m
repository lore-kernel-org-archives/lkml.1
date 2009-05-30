Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZE3Wkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZE3Wkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZE3Wgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:36:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46534 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607AbZE3Wge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:36:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "IDE" <linux-ide@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Mikael Pettersson" <mikpe@it.uu.se>, "Tejun Heo" <tj@kernel.org>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
In-Reply-To: <4to6E2myxvG.A.muC.aIbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LEcEO2518_I.A.8UD.tIbIKB@chimera>
Subject: [Bug #13378] kernel/async.c broke pata_legacy.c
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:37:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13378
Subject		: kernel/async.c broke pata_legacy.c
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-05-24 16:13 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=124318186507210&w=4
Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
Patch		: http://patchwork.kernel.org/patch/25699/


