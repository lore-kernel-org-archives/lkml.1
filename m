Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbZEPWSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbZEPWSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbZEPWOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:14:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622AbZEPWOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:14:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Laurent Pinchart" <laurent.pinchart@skynet.be>,
       "Ming Lei" <tom.leiming@gmail.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.MDC.iZzDKB@chimera>
Subject: [Bug #13125] active uvcvideo breaks over suspend
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:38 +0200 (CEST)
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
Date		: 2009-04-15 10:12 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=123979009508840&w=4
Handled-By	: Ming Lei <tom.leiming@gmail.com>
Patch		: http://lkml.org/lkml/2009/4/18/5


