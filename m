Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbXKWAft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbXKWAft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 19:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbXKWAfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 19:35:41 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:53127 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbXKWAfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:35:40 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 22 Nov 2007 16:35:38 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Where is the new timerfd?
In-Reply-To: <20071122162430.48f55995.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711221634510.7431@alien.or.mcafeemobile.com>
References: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com>
 <Pine.LNX.4.64.0711220933330.7256@alien.or.mcafeemobile.com>
 <cfd18e0f0711221048k538d05abk8e4303d5f90a6e1b@mail.gmail.com>
 <Pine.LNX.4.64.0711221145410.7431@alien.or.mcafeemobile.com>
 <20071122162430.48f55995.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007, Andrew Morton wrote:

> On Thu, 22 Nov 2007 11:46:13 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > On Thu, 22 Nov 2007, Michael Kerrisk wrote:
> > 
> > > On Nov 22, 2007 6:34 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > > > On Thu, 22 Nov 2007, Michael Kerrisk wrote:
> > > >
> > > > > Hey Davide,
> > > > >
> > > > > Where is the new timerfd API.  In 2.6.24-rc3, I see the *old* API...
> > > >
> > > > Maybe Andrew stuffed the turkey with it? :) It was there. I remeber it was
> > > > merged. Some screw up reverted it?
> > > 
> > > t looks that way.
> > 
> > I'm looking at the log now. It never went in actually. Andrew-san, what 
> > happened?
> > 
> 
> Last I recall, we removed the API for 2.6.23 because we intended to do a
> different interface for 2.6.24.
> 
> But I don't recall seeing any timerfd patches in maybe a month.

Was sent on Sep 23, Subject: new timerfd API
Do you want me to repost?



- Davide


