Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYC1AXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYC1AXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYC1AXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:23:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbYC1AXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:23:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Date: Fri, 28 Mar 2008 01:23:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803272353.51901.rjw@sisk.pl> <20080328001804.GA11075@localhost.ift.unesp.br>
In-Reply-To: <20080328001804.GA11075@localhost.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803280123.28207.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 of March 2008, Carlos R. Mafra wrote:
> On Thu 27.Mar'08 at 23:53:50 +0100, Rafael J. Wysocki wrote:
> > This message contains a list of some regressions from 2.6.24 reported since
> > 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> > of.  If any of them have been fixed already, please let me know.
> > [...]
>  
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10343
> > Subject		: 103 sec. latency: sync_page() with TASK_UNINTERRUPTIBLE (?) (bisected)
> > Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
> > Date		: 2008-03-23 00:47 (5 days old)
> > References	: http://lkml.org/lkml/2008/3/22/211
> > Handled-By	: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> This regression is already solved. The patch which caused this problem 
> was reverted by Andrew Morton in 4dd4b920218326231156c7991ce5b94afad841c3.

Thanks, closed.

Rafael
