Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYCPXjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYCPXjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYCPXjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:39:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbYCPXjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:39:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
Date: Mon, 17 Mar 2008 00:38:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Linas =?iso-8859-2?q?=AEvirblis?= <0x0007@gmail.com>
References: <200803170018.52663.rjw@sisk.pl> <alpine.LFD.1.00.0803161628410.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803161628410.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803170038.29253.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 17 of March 2008, Linus Torvalds wrote:
> 
> On Mon, 17 Mar 2008, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9983
> > Subject		: PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
> > Submitter	: Linas ®virblis <0x0007@gmail.com>
> > Date		: 2008-02-13 22:38 (33 days old)
> > References	: http://lkml.org/lkml/2008/2/13/566
> 
> This is most likely already fixed by commit
> e82cc1288fa57857c6af8c57f3d07096d4bcd9d9.
> 
> Unless Linas can reproduce it with a newer kernel (I'm cutting an -rc6 
> right now, but any -git snapshot in the last few days should work) this 
> one should be closed.  We can't keep things open just because the tester 
> hasn't tested.

Sure, I'll close it if there's no response in a couple of days.

Thanks,
Rafael
