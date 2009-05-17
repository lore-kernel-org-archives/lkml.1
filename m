Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZEQQJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZEQQJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 12:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZEQQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 12:08:49 -0400
Received: from pearlgates.net ([82.92.180.13]:35986 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbZEQQIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 12:08:48 -0400
Date: Sun, 17 May 2009 18:08:48 +0200
From: Jos van der Ende <seraph@xs4all.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Jos van der Ende" <seraph@xs4all.nl>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug #12947] r128: system hangs when X is started with DRI
 enabled
Message-Id: <20090517180848.9f20a768.seraph@xs4all.nl>
In-Reply-To: <pQ9WADCjgyE.A.XPH.6A0DKB@chimera>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
	<pQ9WADCjgyE.A.XPH.6A0DKB@chimera>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 22:05:58 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).

The bug is still present in 2.6.29.3, but we've found the likely cause and a potential fix. As soon as I have access to the system again, I will test this patch. Unfortunately I won't be anywhere near the system this week. I'll get back to it on Monday 25th.


-- 
Jos van der Ende <seraph@xs4all.nl>
