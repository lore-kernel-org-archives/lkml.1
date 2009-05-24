Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbZEXWIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbZEXWIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbZEXWHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:07:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34169 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384AbZEXWHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:07:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Laurent Pinchart" <laurent.pinchart@skynet.be>,
       "Ming Lei" <tom.leiming@gmail.com>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uSztiUhmDDC.A.B-B.0-bGKB@chimera>
Subject: [Bug #13125] active uvcvideo breaks over suspend
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:11:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13125
Subject		: active uvcvideo breaks over suspend
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2009-04-15 10:12 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=123979009508840&w=4
Handled-By	: Ming Lei <tom.leiming@gmail.com>
Patch		: http://lkml.org/lkml/2009/4/18/5


