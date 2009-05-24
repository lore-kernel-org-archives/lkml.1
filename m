Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbZEXWMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbZEXWMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbZEXWI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:08:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34234 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759003AbZEXWIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:08:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Jeff Moyer" <jmoyer@redhat.com>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Jim Rees" <rees@umich.edu>, "Olga Kornievskaia" <aglo@citi.umich.edu>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uSztiUhmDDC.A.3g.s9bGKB@chimera>
Subject: [Bug #13323] 2.6.30-rc deadline scheduler performance regression for iozone over NFS
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:11:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13323
Subject		: 2.6.30-rc deadline scheduler performance regression for iozone over NFS
Submitter	: Jeff Moyer <jmoyer@redhat.com>
Date		: 2009-04-23 14:01 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=124049547915450&w=4


