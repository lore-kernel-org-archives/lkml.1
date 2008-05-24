Return-Path: <linux-kernel-owner+w=401wt.eu-S1762247AbYEXVi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762247AbYEXVi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762662AbYEXVdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:33:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761388AbYEXVdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:33:00 -0400
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "David Brownell" <david-b@pacbell.net>,
       "Lennert Buytenhek" <buytenh@wantstofly.org>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A._IE.zeIOIB@albercik>
Subject: [Bug #10713] ehci splatter in 2.6.26-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10713
Subject		: ehci splatter in 2.6.26-rc2
Submitter	: Lennert Buytenhek <buytenh@wantstofly.org>
Date		: 2008-05-14 11:24 (11 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121076435420129&amp;w=4
Handled-By	: David Brownell <david-b@pacbell.net>
		  Lennert Buytenhek <buytenh@wantstofly.org>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: http://lkml.org/lkml/2008/5/20/149


