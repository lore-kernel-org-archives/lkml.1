Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbYC1S6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbYC1S6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYC1S5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:57:54 -0400
Received: from rtr.ca ([76.10.145.34]:4647 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbYC1S5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:57:53 -0400
Message-ID: <47ED3FB0.3060800@rtr.ca>
Date: Fri, 28 Mar 2008 14:57:52 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
References: <200803272353.51901.rjw@sisk.pl>
In-Reply-To: <200803272353.51901.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
..
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10345
> Subject		: 2.6.25-rc7: Ugh. (USB HID problems after resume)
> Submitter	: Mark Lord <lkml@rtr.ca>
> Date		: 2008-03-27 11:29 (1 days old)
> References	: http://lkml.org/lkml/2008/3/27/228
> Handled-By	: Greg KH <gregkh@suse.de>
..

Greg didn't really look at this one.
Change the "Handled-By" to:

  Handled-By	: Mark Lord <lkml@rtr.ca>
 
Also, for now it seems to be "resolved" via a seemingly-unrelated
change in the .config file on that machine.  If it dies again,
I'll re-post and investigate further.

Thanks for doing this stuff!
