Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbXKWRaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbXKWRaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 12:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXKWR35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 12:29:57 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:59253 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbXKWR35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 12:29:57 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 23 Nov 2007 09:29:54 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Where is the new timerfd?
In-Reply-To: <20071123091254.45f4193d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711230928590.15603@alien.or.mcafeemobile.com>
References: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com>
 <Pine.LNX.4.64.0711220933330.7256@alien.or.mcafeemobile.com>
 <cfd18e0f0711221048k538d05abk8e4303d5f90a6e1b@mail.gmail.com>
 <Pine.LNX.4.64.0711221145410.7431@alien.or.mcafeemobile.com>
 <20071122162430.48f55995.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711221634510.7431@alien.or.mcafeemobile.com>
 <20071122173437.e74890a8.akpm@linux-foundation.org>
 <cfd18e0f0711230439m1d72abdle4d5050b0bd935a1@mail.gmail.com>
 <20071123091254.45f4193d.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007, Andrew Morton wrote:

> > I suppose this means that timerfd will only go in for 2.6.25.  I don't
> > have a problem with that, but we better make sure that the existing
> > timerfd in 2.6.24 is still disabled.  (Andrew had a one liner for
> > that, but I haven't checked if it's in place.)
> > 
> 
> I have no timerfd patches here.

Yes, it's disabled, and yes, I'll repost today ...


- Davide


