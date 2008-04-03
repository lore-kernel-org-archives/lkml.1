Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYDCXfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYDCXfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYDCXfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:35:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYDCXfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:35:01 -0400
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Zhang@ogre.sisk.pl,
       Yanmin <yanmin_zhang@linux.intel.com>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.ieB.zIW9HB@albercik>
Subject: 2.6.25-rc1: volanoMark regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 00:50:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
Subject		: 2.6.25-rc1: volanoMark regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-13 10:30 (51 days old)
References	: http://lkml.org/lkml/2008/2/13/128
Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


