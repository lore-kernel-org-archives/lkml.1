Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbZCPV5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbZCPV5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbZCPV4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:56:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbZCPV4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:56:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #12870] 2.6.29-rc "TKIP: replay detected" regression
Date: Mon, 16 Mar 2009 22:57:06 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.mbC.M4BvJB@chimera> <Pine.LNX.4.64.0903162150060.28429@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0903162150060.28429@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903162257.07386.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009, Hugh Dickins wrote:
> On Sat, 14 Mar 2009, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12870
> > Subject		: 2.6.29-rc "TKIP: replay detected" regression
> > Submitter	: Hugh Dickins <hugh@veritas.com>
> > Date		: 2009-03-11 12:07 (4 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123677337219148&w=4
> > Handled-By	: John W. Linville <linville@tuxdriver.com>
> 
> Yes, it should still be listed, but could go into the "with patches"
> section: there's a good patch from John in linux-next, which I expect
> he'll get Linus to pull in due course.

Well, I need a pointer to the patch please.  John?

Rafael
