Return-Path: <linux-kernel-owner+w=401wt.eu-S1761143AbYDDAPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761143AbYDDAPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758392AbYDDAHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956AbYDDAHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:16 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Len Brown <len.brown@intel.com>,
       Zhang Rui <rui.zhang@intel.com>, Zhao Yakui <yakui.zhao@intel.com>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.2E.vDW9HB@albercik>
Subject: rc6+ regression - backlight reset to 0 on boot after 7c0ea45be4f114d85ee35caeead8e1660699c46f
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10387
Subject		: rc6+ regression - backlight reset to 0 on boot after 7c0ea45be4f114d85ee35caeead8e1660699c46f
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-04-02 22:53 (2 days old)
References	: http://lkml.org/lkml/2008/4/2/366


