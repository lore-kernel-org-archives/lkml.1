Return-Path: <linux-kernel-owner+w=401wt.eu-S1761588AbYDDAOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbYDDAOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758327AbYDDAH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897AbYDDAHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:15 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Balaji Rao <balajirrao@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Yanko Kaneti <yaneti@declera.com>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.KN.1DW9HB@albercik>
Subject: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10382
Subject		: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
Submitter	: Yanko Kaneti <yaneti@declera.com>
Date		: 2008-04-02 10:59 (2 days old)
References	: http://lkml.org/lkml/2008/4/2/210
Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>
		  Balaji Rao <balajirrao@gmail.com>


