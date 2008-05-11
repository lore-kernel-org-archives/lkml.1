Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbYEKVjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbYEKVjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbYEKViz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:38:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34566 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbYEKViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:38:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [Bug #10641] [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than 120 seconds
Date: Sun, 11 May 2008 23:39:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.9QH.Bw1JIB@chimera> <20080511212105.GK1645@cs181133002.pp.htv.fi>
In-Reply-To: <20080511212105.GK1645@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805112339.11246.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 of May 2008, Adrian Bunk wrote:
> On Sun, May 11, 2008 at 10:04:15PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10641
> > Subject		: [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than 120 seconds
> > Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > Date		: 2008-05-07 13:34 (5 days old)
> > References	: http://marc.info/?l=linux-kernel&amp;m=121016673607188&amp;w=2
> > Handled-By	: Adrian Bunk <bunk@kernel.org>
> 
> I'm not handling this one.

Thanks for letting me know, I've updated the bug entry to reflect this (well,
let's see if the new mechanics in the script works ;-)).

Thanks,
Rafael
