Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbYHBT2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbYHBT2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759100AbYHBT2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:28:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38017 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759054AbYHBT2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:28:06 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Matthew Wilcox" <willy@linux.intel.com>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
In-Reply-To: <cbItfVMShGI.A.olC.UMLlIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5ZeQ4vXWqRC.A.q2E.4NLlIB@albercik>
Subject: [Bug #11178] Secondary hard drive fails during both hibernation and resume.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  2 Aug 2008 20:04:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed
and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11178
Subject		: Secondary hard drive fails during both hibernation and resume.
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-07-30 04:53 (4 days old)
Handled-By	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17043&action=view


