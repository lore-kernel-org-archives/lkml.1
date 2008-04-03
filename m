Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYDDAMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYDDAMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYDDAHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286AbYDDAHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:12 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Meelis Roos <mroos@linux.ee>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.Dd.HEW9HB@albercik>
Subject: regression: am-utils stopped working in 2.6.25-rc*
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10349
Subject		: regression: am-utils stopped working in 2.6.25-rc*
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2008-03-28 15:20 (7 days old)
References	: http://lkml.org/lkml/2008/3/28/174


