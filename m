Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZDYWWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZDYWWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZDYWSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:18:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbZDYWSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:18:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Dan Williams" <dan.j.williams@intel.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.qeD.Md48JB@chimera>
Subject: [Bug #13124] ioatdma: DMA-API: device driver frees DMA memory with wrong function
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13124
Subject		: ioatdma: DMA-API: device driver frees DMA memory with wrong function
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-09 12:36 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=123928064322503&w=4
Handled-By	: Dan Williams <dan.j.williams@intel.com>


