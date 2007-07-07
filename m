Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbXGGO4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbXGGO4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 10:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXGGO4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 10:56:40 -0400
Received: from gherkin.frus.com ([192.158.254.49]:32936 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbXGGO4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 10:56:38 -0400
Subject: Re: 2.6.22-rc6 bad page error
In-Reply-To: <6bffcb0e0707070648v4d4af21i7c77ac931bfaaed7@mail.gmail.com>
 "from Michal Piotrowski at Jul 7, 2007 03:48:36 pm"
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date: Sat, 7 Jul 2007 09:56:36 -0500 (CDT)
CC: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070707145636.0034BDBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi Bob,
> 
> On 05/07/07, Bob Tracy <rct@gherkin.frus.com> wrote:
> > This happened on an Alpha computer (433au) running 2.6.22-rc6.
> 
> Can you reproduce this bug on 2.6.22-rc7-git6?
> 
> >  The
> > error was triggered when I started up a NX KDE session, which I've
> > done successfully on all occasions prior to this one.  In other words,
> > I wasn't doing anything out of the ordinary...  The machine is still up
> > and running as I type this, and can't/won't be rebooted for a few hours
> > if there's any other troubleshooting information I need to retrieve that
> > might be helpful.

ACK on the suggestion to try -rc7-git6, but I'll probably wait until
Monday to give it a try.  The client side of my NX "test fixture" is
at my day job location :-).

-- 
-----------------------------------------------------------------------
Bob Tracy               | "Eagles may soar, but weasels don't get
rct@frus.com            |  sucked into jet engines."       --Anon
-----------------------------------------------------------------------
