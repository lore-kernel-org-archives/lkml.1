Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYC1Wh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYC1Wh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbYC1WhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:37:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54911 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbYC1WhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:37:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Date: Fri, 28 Mar 2008 23:37:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803272353.51901.rjw@sisk.pl> <47ED3FB0.3060800@rtr.ca>
In-Reply-To: <47ED3FB0.3060800@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803282337.09211.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 of March 2008, Mark Lord wrote:
> Rafael J. Wysocki wrote:
> ..
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10345
> > Subject		: 2.6.25-rc7: Ugh. (USB HID problems after resume)
> > Submitter	: Mark Lord <lkml@rtr.ca>
> > Date		: 2008-03-27 11:29 (1 days old)
> > References	: http://lkml.org/lkml/2008/3/27/228
> > Handled-By	: Greg KH <gregkh@suse.de>
> ..
> 
> Greg didn't really look at this one.
> Change the "Handled-By" to:
> 
>   Handled-By	: Mark Lord <lkml@rtr.ca>
>  
> Also, for now it seems to be "resolved" via a seemingly-unrelated
> change in the .config file on that machine.  If it dies again,
> I'll re-post and investigate further.

I've closed it as "unreproducible", please reopen if necessary.

> Thanks for doing this stuff!

You're welcome. :-)
