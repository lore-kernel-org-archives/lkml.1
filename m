Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbZDQAoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbZDQAoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759768AbZDQAex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:34:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759735AbZDQAev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:34:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Dan Williams" <dan.j.williams@intel.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.8nG.-v85JB@chimera>
Subject: [Bug #13124] ioatdma: DMA-API: device driver frees DMA memory with wrong function
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:07 +0200 (CEST)
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
Date		: 2009-04-09 12:36 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123928064322503&w=4
Handled-By	: Dan Williams <dan.j.williams@intel.com>


