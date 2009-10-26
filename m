Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZJZNMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZJZNMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZJZNMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:12:06 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:55721 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452AbZJZNMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:12:05 -0400
From: Frans Pop <elendil@planet.nl>
To: Robert Bradbury <robert.bradbury@gmail.com>
Subject: Re: RFC: Updating the LKML bug reporting/updating framework
Date: Mon, 26 Oct 2009 14:12:05 +0100
User-Agent: KMail/1.9.9
Cc: tmb@mandriva.org, linux-kernel@vger.kernel.org
References: <deaa866a0910251559r6c001e6ek553256ac8f81b1f7@mail.gmail.com> <4AE4E026.9070402@mandriva.org> <4AE4E026.9070402@mandriva.org> <deaa866a0910260512p1eca02f6k89aa180aec27558d@mail.gmail.com>
In-reply-To: <deaa866a0910260512p1eca02f6k89aa180aec27558d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910261412.07980.elendil@planet.nl>
X-OriginalArrivalTime: 26 Oct 2009 13:12:08.0615 (UTC) FILETIME=[EC03DB70:01CA563D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Bradbury wrote:
> Given the bugzilla database, is the LKML with its high volume and
> noise level (IMO), now largely obsolete [1]?

No, it's not. Many issues benefit from a mail-based discussion where many 
people can follow the thread and jump in if something strikes them.
People subscribed to lkml will generally have their own methods of 
filtering out mails/subjects/threads that interest them.

Some subsystems (like acpi) prefer to handle bugs using bugzilla; others 
(netdev, ide) have dedicated mailing lists. All regressions are tracked in 
bugzilla, even if many are initially reported on mailing lists.

lkml still has an important function for those who wish to keep a good 
general overview of what's happening. There are a few people who keep an 
active watch on lkml to spot bug reports and to ensure they are brought to 
the attention of the right people.
You are not required to subscribe to lkml to report an issue on it: the 
policy is to always reply-to-all.

If you prefer to use bugzilla, go ahead. Some subsystem maintainers will 
then handle the bug in bugzilla; others may switch to email.

> (I think I a Google search may have led me in the direction that it was
> the place to report bugs).

It depends. It's the one place where you can always report an issue if you 
don't know where else to report it. The best way to report issues is to do 
so directly to relevant maintainers, but that requires some familiarity 
with the source and the community.

Cheers,
FJP
