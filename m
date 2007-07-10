Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbXGJQ25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbXGJQ25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbXGJQ2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:28:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54005 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbXGJQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:28:48 -0400
Date: Tue, 10 Jul 2007 09:29:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: -mm merge plans for 2.6.23 (pcmcia)
Message-Id: <20070710092958.03b058d8.randy.dunlap@oracle.com>
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 01:31:52 -0700 Andrew Morton wrote:

> 
> When replying, please rewrite the subject suitably and try to Cc: the
> appropriate developer(s).

...

> pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
> use-menuconfig-objects-pcmcia.patch
> 
>  Am a bit stuck with the pcmcia patches.  Dominik has disappeared.

The menuconfig patch looks fine.

I looked at the May-2007 discussion of ioctl removal.
I don't see that much has changed since then, so it's either be
brave/foolish/whatever and see what happens or just wait.
I'll gladly send a patch to update the removal date in
feature-removal-schedule.txt

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
