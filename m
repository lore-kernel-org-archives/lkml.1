Return-Path: <linux-kernel-owner+w=401wt.eu-S1761893AbZCQAPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761893AbZCQAPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZCQAPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:15:35 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56188 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZCQAPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:15:34 -0400
Date: Mon, 16 Mar 2009 20:11:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12870] 2.6.29-rc "TKIP: replay detected" regression
Message-ID: <20090317001136.GA3650@tuxdriver.com>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.mbC.M4BvJB@chimera> <Pine.LNX.4.64.0903162150060.28429@blonde.anvils> <200903162257.07386.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903162257.07386.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 10:57:06PM +0100, Rafael J. Wysocki wrote:
> On Monday 16 March 2009, Hugh Dickins wrote:
> > On Sat, 14 Mar 2009, Rafael J. Wysocki wrote:
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12870
> > > Subject		: 2.6.29-rc "TKIP: replay detected" regression
> > > Submitter	: Hugh Dickins <hugh@veritas.com>
> > > Date		: 2009-03-11 12:07 (4 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=123677337219148&w=4
> > > Handled-By	: John W. Linville <linville@tuxdriver.com>
> > 
> > Yes, it should still be listed, but could go into the "with patches"
> > section: there's a good patch from John in linux-next, which I expect
> > he'll get Linus to pull in due course.
> 
> Well, I need a pointer to the patch please.  John?

http://marc.info/?l=linux-wireless&m=123678463704691&w=2

Just sent a pull request through Dave...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
