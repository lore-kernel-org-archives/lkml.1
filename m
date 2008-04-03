Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbYDDANs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbYDDANs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbYDDAHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbYDDAHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:12 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Dave Airlie <airlied@gmail.com>, Tilman Schmidt <tilman@imap.cc>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.3i.VEW9HB@albercik>
Subject: [2.6.25-rc6] possible regression: X server dying
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10344
Subject		: [2.6.25-rc6] possible regression: X server dying
Submitter	: Tilman Schmidt <tilman@imap.cc>
Date		: 2008-03-24 23:38 (11 days old)
References	: http://lkml.org/lkml/2008/3/24/260
Handled-By	: Dave Airlie <airlied@gmail.com>


