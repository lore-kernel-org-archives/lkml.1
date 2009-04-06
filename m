Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbZDFV6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbZDFV6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbZDFVvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:51:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49949 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760029AbZDFVvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:51:53 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <optimusgd@gmail.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AsKNxFx2juN.A.QlH.7Fn2JB@chimera>
Subject: [Bug #13001] PCI-DMA: Out of IOMMU space
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  6 Apr 2009 21:05:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13001
Subject		: PCI-DMA: Out of IOMMU space
Submitter	:  <optimusgd@gmail.com>
Date		: 2009-04-03 09:30 (4 days old)


