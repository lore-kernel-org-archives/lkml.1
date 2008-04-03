Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbYDDANa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbYDDANa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbYDDAHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34899 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402AbYDDAHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:13 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Bjoern Steinbrink <B.Steinbrink@gmx.de>, Bob Tracy <rct@frus.com>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.2X.BEW9HB@albercik>
Subject: 2.6.25-rc7: warn_on_slowpath triggered
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10366
Subject		: 2.6.25-rc7: warn_on_slowpath triggered
Submitter	: Bob Tracy <rct@frus.com>
Date		: 2008-03-29 17:29 (6 days old)
References	: http://lkml.org/lkml/2008/3/29/125
Handled-By	: Bjoern Steinbrink <B.Steinbrink@gmx.de>
Patch		: http://lkml.org/lkml/2008/3/30/245


