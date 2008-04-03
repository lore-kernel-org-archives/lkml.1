Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbYDCXuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbYDCXuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYDCXtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:49:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34794 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758078AbYDCXtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:49:50 -0400
Cc: Jasper Bryant-Greene <jasper@unix.geek.nz>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.XbB.vIW9HB@albercik>
Subject: 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it to hang
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:05:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9980
Subject		: 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it to hang
Submitter	: Jasper Bryant-Greene <jasper@unix.geek.nz>
Date		: 2008-02-13 12:25 (51 days old)
References	: http://lkml.org/lkml/2008/2/13/181


