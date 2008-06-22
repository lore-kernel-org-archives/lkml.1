Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYFVTHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYFVTHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYFVTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:05:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36250 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbYFVTFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:05:04 -0400
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.jRD._spXIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4mRZUF-hVeG.A.udG.CwpXIB@albercik>
Subject: [Bug #10714] powerpc: Badness seen on 2.6.26-rc2 with lockdep enabled
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2008 19:54:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
Subject		: powerpc: Badness seen on 2.6.26-rc2 with lockdep enabled
Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
Date		: 2008-05-14 12:57 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=121076917429133&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


