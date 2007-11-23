Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbXKWRN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbXKWRN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 12:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXKWRNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 12:13:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbXKWRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 12:13:19 -0500
Date: Fri, 23 Nov 2007 09:12:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Where is the new timerfd?
Message-Id: <20071123091254.45f4193d.akpm@linux-foundation.org>
In-Reply-To: <cfd18e0f0711230439m1d72abdle4d5050b0bd935a1@mail.gmail.com>
References: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com>
	<Pine.LNX.4.64.0711220933330.7256@alien.or.mcafeemobile.com>
	<cfd18e0f0711221048k538d05abk8e4303d5f90a6e1b@mail.gmail.com>
	<Pine.LNX.4.64.0711221145410.7431@alien.or.mcafeemobile.com>
	<20071122162430.48f55995.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0711221634510.7431@alien.or.mcafeemobile.com>
	<20071122173437.e74890a8.akpm@linux-foundation.org>
	<cfd18e0f0711230439m1d72abdle4d5050b0bd935a1@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007 13:39:55 +0100 "Michael Kerrisk" <mtk.manpages@googlemail.com> wrote:

> On 11/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 22 Nov 2007 16:35:38 -0800 (PST) Davide Libenzi
> > <davidel@xmailserver.org> wrote:
> >
> > > On Thu, 22 Nov 2007, Andrew Morton wrote:
> [...]
> > > > Last I recall, we removed the API for 2.6.23 because we intended to do a
> > > > different interface for 2.6.24.
> > > >
> > > > But I don't recall seeing any timerfd patches in maybe a month.
> > >
> > > Was sent on Sep 23, Subject: new timerfd API
> >
> > Half of us weren't born then ;)
> >
> > > Do you want me to repost?
> >
> > yes please.
> 
> I suppose this means that timerfd will only go in for 2.6.25.  I don't
> have a problem with that, but we better make sure that the existing
> timerfd in 2.6.24 is still disabled.  (Andrew had a one liner for
> that, but I haven't checked if it's in place.)
> 

I have no timerfd patches here.
