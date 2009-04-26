Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZDZNgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZDZNgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZDZNgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:36:01 -0400
Received: from mail001.aei.ca ([206.123.6.130]:37627 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZDZNgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:36:00 -0400
From: Ed Tomlinson <edt@aei.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Date: Sun, 26 Apr 2009 09:35:55 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-crc; KDE/4.2.2; x86_64; ; )
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <200904170752.48078.edt@aei.ca> <200904171648.38172.rjw@sisk.pl>
In-Reply-To: <200904171648.38172.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904260935.56655.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009 10:48:38 you wrote:
> On Friday 17 April 2009, Ed Tomlinson wrote:
> > On Thursday 16 April 2009 17:42:31 you wrote:
> > > If you know of any other unresolved regressions from 2.6.29, please let me know
> > > either and I'll add them to the list.  Also, please let me know if any of the
> > > entries below are invalid.
> > 
> > Rafael,
> > 
> > Do you want a bug raised?  The stall reported in thread "2.6.30-rc1 A few issues and a stall"
> > is still a problem with rc2.  The other issues mentioned in the thread are fixed.
> 
> If there's only one issue remaining unfixed, please file a bug in the Bugzilla
> and put my address in the CC list of the bug entry.

There is not need for me to raise a bug.  The problem is fixed with rc3 + Dave Miller's latest
network tree for Linus.

Thanks
Ed
