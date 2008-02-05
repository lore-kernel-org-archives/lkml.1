Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYBEUT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYBEUT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759033AbYBEUTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:19:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45156 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759038AbYBEUTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:19:46 -0500
Date: Tue, 5 Feb 2008 12:19:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: arjan@linux.intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1
Message-Id: <20080205121914.e3986172.akpm@linux-foundation.org>
In-Reply-To: <3289.1202240894@turing-police.cc.vt.edu>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	<10779.1202230436@turing-police.cc.vt.edu>
	<47A89664.8020407@linux.intel.com>
	<3289.1202240894@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 14:48:14 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Tue, 05 Feb 2008 09:01:24 PST, Arjan van de Ven said:
> > Valdis.Kletnieks@vt.edu wrote:
> > > On Sun, 03 Feb 2008 17:16:34 PST, Andrew Morton said:
> > >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
> > > 
> > > Builds, boots, mostly seems to run for limited testing.
> > > 
> > > One note - the following commit(s) (and related CPA reworking) broke the NVidia
> > > binary driver (which is OK, I can fix *that* part).  But can somebody explain
> > > if this should have seen a trip through the -mm tree before it hit mainstream?
> > > I didn't see these in 24-rc8-mm1:
> > 
> > well that depends on which -mm you tried; I'm sure the mm kernel of the day had it for a while.
> 
> I looked around on www.kernel.org, and I found this directory:
> 
> http://www.kernel.org/pub/linux/kernel/people/akpm/mm/ but the most recent is:
> 
> broken-out-2007-11-20-01-45.tar.bz2      20-Nov-2007 09:45  3.4M

http://userweb.kernel.org/~akpm/mmotm/ contains the latest -mm tree.  Updated
more-than-daily when it's changing.
