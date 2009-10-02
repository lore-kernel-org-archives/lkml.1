Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZJBHPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZJBHPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbZJBHPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:15:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:60163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091AbZJBHPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:15:11 -0400
Subject: Re: [Bug #14058] Oops in fsnotify
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Paris <eparis@parisplace.org>,
       Grant Wilson <grant.wilson@zen.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, "Theodore Ts'o" <tytso@mit.edu>,
       paulmck@linux.vnet.ibm.com
In-Reply-To: <COE24pZSBH.A.CTC.zNTxKB@chimera>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <COE24pZSBH.A.CTC.zNTxKB@chimera>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 12:44:20 +0530
Message-Id: <1254467660.3531.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grant,

On Thu, 2009-10-01 at 21:55 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14058
> Subject		: Oops in fsnotify
> Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
> Date		: 2009-08-20 15:48 (43 days old)
> References	: http://marc.info/?l=linux-kernel&m=125078450923133&w=4
> 
> 

Are you still facing this oops in latest kernel. If yes, can you do
git bisect and specify the commit.

Thanks,
--
JSR

