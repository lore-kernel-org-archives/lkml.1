Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbYFOKrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbYFOKrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 06:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYFOKrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 06:47:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52304 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbYFOKrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 06:47:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?iso-8859-1?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug 10864] [regression][bisected] ~90,000 wakeups as of 2.6.26-rc3
Date: Sun, 15 Jun 2008 12:48:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <20080615075008.GD29552@elte.hu> <4854D8C8.8080006@freemail.hu>
In-Reply-To: <4854D8C8.8080006@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806151248.08661.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 15 of June 2008, Németh Márton wrote:
> Ingo Molnar wrote:
> > * Németh Márton <nm127@freemail.hu> wrote:
> > 
> >> Hi,
> >>
> >> I already mentioned at the bug report that 2.6.26-rc6 this is fixed.
> >>
> >> Maybe tell your robot to first check the latest activities in the bug 
> >> report since the last -rc release. What I want also to tell your robot 
> >> that it should mention what actions should be taken in case the bug 
> >> should be still listed or when the bug can be closed.
> > 
> > i think the current regression tracking methods that Rafael uses work 
> > very well and i'd like to thank Rafael for those efforts - to me as a 
> > subsystem maintainer it is a _very_ useful thing.

Thanks Ingo!

> > In this case there was no real harm from the "this bug is already fixed" 
> > condition - just an extra email. Real harm would only come from missed 
> > regressions or from incorrectly closed regressions - but those are not 
> > happening.
> > 
> > note that there is no "robot" involved in changing the state of bugs - 
> > the real important work here is done by Rafael and checking whether a 
> > bug is still relevant is an inevitably manual work. The mails and 
> > reports are auto-generated but crawling discussions and determining the 
> > status of a regression is very hard to automate.
> 
> Sorry, I thought a robot missed my comments in the bug tracking system for
> the second time:
> 
> 1.
> Comment was on 2008-06-06 13:27:16 ( http://bugzilla.kernel.org/show_bug.cgi?id=10864#c3 )
> The mail was coming: 7 Jun 2008 22:42:57 +0200 (CEST) ( http://lkml.org/lkml/2008/6/7/193 )
> 
> 2.
> Comment was on 2008-06-13 23:19:53 ( http://bugzilla.kernel.org/show_bug.cgi?id=10864#c4 )
> The mail was coming: 14 Jun 2008 22:12:04 +0200 (CEST) ( http://lkml.org/lkml/2008/6/14/160 )
> 
> Nevertheless the bug #10864 can be closed I think.

Closed now.

Thanks,
Rafael
