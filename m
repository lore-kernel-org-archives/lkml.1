Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYDDAME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYDDAME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbYDDAHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbYDDAHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:12 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Georgi Chorbadzhiyski <gf@unixsol.org>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.nf.JEW9HB@albercik>
Subject: Linux 2.6.25-rc6: WARNING: at net/ipv4/tcp_input.c:2510
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10346
Subject		: Linux 2.6.25-rc6: WARNING: at net/ipv4/tcp_input.c:2510
Submitter	: Georgi Chorbadzhiyski <gf@unixsol.org>
Date		: 2008-03-27 17:29 (8 days old)
References	: http://lkml.org/lkml/2008/3/27/246


