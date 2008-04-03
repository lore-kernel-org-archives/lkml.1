Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbYDDAFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbYDDAFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYDDAEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:04:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34852 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYDDAEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:04:54 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Toralf Feorster <toralf.foerster@gmx.de>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.iUB.YHW9HB@albercik>
Subject: TUNER_TDA8290=y, VIDEO_DEV=n build error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:20:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10067
Subject		: TUNER_TDA8290=y, VIDEO_DEV=n build error
Submitter	: Toralf Foerster <toralf.foerster@gmx.de>
Date		: 2008-02-22 10:36 (42 days old)
References	: http://lkml.org/lkml/2008/2/19/262


