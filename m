Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbZCCWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbZCCWJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbZCCWA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39401 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758482AbZCCWA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:00:56 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Thomas Hellstrom" <thellstrom@vmware.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.GrB.yUarJB@chimera>
Subject: [Bug #12800] x86 PAT invalid vm_insert_pfn assumptions
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12800
Subject		: x86 PAT invalid vm_insert_pfn assumptions
Submitter	: Thomas Hellstrom <thellstrom@vmware.com>
Date		: 2009-03-02 01:40 (2 days old)


