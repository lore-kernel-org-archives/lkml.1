Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYKPSmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYKPSmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYKPSfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:35:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42998 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbYKPSfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:35:08 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.FeE.SAGIJB@chimera>
Subject: [Bug #12031] DRM enabled kernel hangs hard on resume on x60
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12031
Subject		: DRM enabled kernel hangs hard on resume on x60
Submitter	: Jens Axboe <jens.axboe@oracle.com>
Date		: 2008-11-12 18:42 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=122651551216820&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


