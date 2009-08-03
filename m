Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZHCUZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZHCUZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZHCUZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:25:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZHCUZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:25:43 -0400
Date: Mon, 3 Aug 2009 13:25:27 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [Bug #13726] fio sync read 4k block size 35% regression
In-Reply-To: <iZB3Pj-uj3M.A.1IE.wdgdKB@chimera>
Message-ID: <alpine.DEB.2.01.0908031323220.5831@bogon.housecafe.de>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.1IE.wdgdKB@chimera>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18oc0W/qdyve7mC8UY/OOfCsvoF6PI2jkxy9MM
 LU/AQMqilZZlP0LWB/XNlJ9x0RlZqm4vqxsheW5T6e5robTPIW
 nwtX6y8MI/zEvraSRgweA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009 at 20:58, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13726
> Subject		: fio sync read 4k block size 35% regression
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2009-07-01 11:25 (33 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=51daa88ebd8e0d437289f589af29d4b39379ea76
> References	: http://lkml.org/lkml/2009/6/30/679
> Handled-By	: Wu Fengguang <fengguang.wu@intel.com>

Not sure if the regression is gone, but the submitter wants to:

   http://bugzilla.kernel.org/show_bug.cgi?id=13726#c2
   > I would like to close the report now. If finding new issues with
   > new revised test cases, I will open new reports.


Christian.
-- 
BOFH excuse #15:

temporary routing anomaly
