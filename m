Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbXKWAY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbXKWAY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 19:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbXKWAYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 19:24:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42862 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbXKWAYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:24:49 -0500
Date: Thu, 22 Nov 2007 16:24:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Where is the new timerfd?
Message-Id: <20071122162430.48f55995.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711221145410.7431@alien.or.mcafeemobile.com>
References: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com>
	<Pine.LNX.4.64.0711220933330.7256@alien.or.mcafeemobile.com>
	<cfd18e0f0711221048k538d05abk8e4303d5f90a6e1b@mail.gmail.com>
	<Pine.LNX.4.64.0711221145410.7431@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 11:46:13 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Thu, 22 Nov 2007, Michael Kerrisk wrote:
> 
> > On Nov 22, 2007 6:34 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > > On Thu, 22 Nov 2007, Michael Kerrisk wrote:
> > >
> > > > Hey Davide,
> > > >
> > > > Where is the new timerfd API.  In 2.6.24-rc3, I see the *old* API...
> > >
> > > Maybe Andrew stuffed the turkey with it? :) It was there. I remeber it was
> > > merged. Some screw up reverted it?
> > 
> > t looks that way.
> 
> I'm looking at the log now. It never went in actually. Andrew-san, what 
> happened?
> 

Last I recall, we removed the API for 2.6.23 because we intended to do a
different interface for 2.6.24.

But I don't recall seeing any timerfd patches in maybe a month.
