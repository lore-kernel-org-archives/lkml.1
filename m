Return-Path: <linux-kernel-owner+w=401wt.eu-S1761908AbYDDAPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908AbYDDAPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758443AbYDDAHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986AbYDDAHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:17 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Jan Kara <jack@suse.cz>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A._7H.sDW9HB@albercik>
Subject: Oops while reading /proc/ioports or /proc/iomem
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10390
Subject		: Oops while reading /proc/ioports or /proc/iomem
Submitter	: Jan Kara <jack@suse.cz>
Date		: 2008-04-03 15:25 (1 days old)
References	: http://lkml.org/lkml/2008/4/3/149


