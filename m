Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYCNLjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYCNLjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYCNLjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:39:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54535 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbYCNLjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:39:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc5-git3: Reported regressions from 2.6.24
Date: Fri, 14 Mar 2008 12:38:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Johannes Weiner <hannes@saeurebad.de>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803140136.38549.rjw@sisk.pl> <87bq5i3xce.fsf@saeurebad.de> <alpine.LFD.1.00.0803131838340.3557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803131838340.3557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803141238.03689.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 14 of March 2008, Linus Torvalds wrote:
> 
> On Fri, 14 Mar 2008, Johannes Weiner wrote:
> > 
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10164
> > > Subject		: ntfs build failure on no-mmu
> > > Submitter	: Mike Frysinger <vapier.adi@gmail.com>
> > > Date		: 2008-03-03 11:05 (11 days old)
> > > References	: http://lkml.org/lkml/2008/3/1/179
> > 
> > I found this: http://lkml.org/lkml/2008/3/13/6
> 
> Fixed slightly differently in mainline by Paul Mindt in commit 
> 0738c4bb8f2a8bf15178f852494643b0981f578b ("nommu: Provide 
> is_vmalloc_addr() stub.")

Thanks, closed.

Rafael
