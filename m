Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYEGBoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYEGBoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYEGBoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:44:09 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43240 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751065AbYEGBoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:44:08 -0400
Date: Tue, 6 May 2008 20:44:07 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com, torvalds@linux-foundation.org, lizf@cn.fujitsu.com,
       seto.hidetoshi@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       sivanich@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 125/311] Cpuset hardwall flag: switch cpusets to use the
 bulk cgroup_add_files() API
Message-Id: <20080506204407.96862779.pj@sgi.com>
In-Reply-To: <20080506180006.107b2dcd.akpm@linux-foundation.org>
References: <200804290800.m3T80QFs009131@imap1.linux-foundation.org>
	<6599ad830804290329heea3c5fu7395b1ef71a87881@mail.gmail.com>
	<20080429053804.6d083a7f.akpm@linux-foundation.org>
	<20080506192018.26c1e3b7.pj@sgi.com>
	<20080506180006.107b2dcd.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	==> akpm - what does todays 2.6.25-rc1-mm1-mmotm
> > 	    apply to?
> 
> 2.6.25-rc1.
> 
> <resyncs>
> 
> It _should_ be OK.  Please check?

mmotm works fine now ... probably would have worked fine
before, except for the brain damaged keyboard operator
who is sitting behind my computer monitor - curse him ;).

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
