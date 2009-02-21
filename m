Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZBUTsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZBUTsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 14:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZBUTsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 14:48:17 -0500
Received: from ns.suse.de ([195.135.220.2]:41804 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbZBUTsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:48:16 -0500
Date: Sat, 21 Feb 2009 11:48:07 -0800
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH 0/9] PM: Fixes related to suspend and hibernation for
	2.6.29
Message-ID: <20090221194807.GA13114@suse.de>
References: <200902140157.40869.rjw@sisk.pl> <alpine.LFD.2.00.0902202337040.19156@localhost.localdomain> <200902211038.42169.rjw@sisk.pl> <20090221182902.GB12472@suse.de> <49A056D5.5090909@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A056D5.5090909@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 11:32:37AM -0800, Arjan van de Ven wrote:
> Greg KH wrote:
>> I was not planning to send them for .29, sorry I got confused.  I'll
>> drop them from my tree and Len can send them all to Linus now.
>
> they really really need to go into .29, they are a fix for a regression.
>
> This patch exists for 6 weeks now as a fix for the regression.. why is it 
> so hard to get it sent to Linus???

I think it's because both of us (Len and I) think the other is doing it
:(

Ok, so, Len, are you willing to send these to Linus this week?

thanks,

greg k-h
