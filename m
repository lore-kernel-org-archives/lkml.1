Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbXEMTD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbXEMTD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbXEMTDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:03:53 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4784 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbXEMTDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:03:52 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 13 May 2007 12:03:35 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Charles Gagalac <charle97@yahoo.com>
Subject: Re: [1/2] 2.6.22-rc1: known regressions
In-Reply-To: <6bffcb0e0705131152y2c2035a1rf609ef818e847bb6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705131159240.3212@alien.or.mcafeemobile.com>
References: <46475595.4050105@googlemail.com> 
 <Pine.LNX.4.64.0705131118160.3212@alien.or.mcafeemobile.com>
 <6bffcb0e0705131152y2c2035a1rf609ef818e847bb6@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc trimmed]

On Sun, 13 May 2007, Michal Piotrowski wrote:

> On 13/05/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Sun, 13 May 2007, Michal Piotrowski wrote:
> > 
> > > Subject    : applications under wine freezes
> > > References : http://bugzilla.kernel.org/show_bug.cgi?id=8462
> > > Submitter  : Charles Gagalac <charle97@yahoo.com>
> > > Caused-By  : Davide Libenzi <davidel@xmailserver.org>
> > >              commit 6192bd536f96c6a0d969081bc71ae24f9319bfdc
> > > Handled-By : Davide Libenzi <davidel@xmailserver.org>
> > > Status     : problem is being debugged
> > 
> > This has been fixed. Confirmed by myself and Charles Gagalac. Patches have
> > been sent to Andrew.
> 
> Bugzilla is back. Did you mean this patch
> http://bugzilla.kernel.org/show_bug.cgi?id=8462#c8 ?

That one does not apply on the latest mainline, and comments are 
broken. There are two new patches posted on lkml:

http://lkml.org/lkml/2007/5/11/412
http://lkml.org/lkml/2007/5/11/413



- Davide


