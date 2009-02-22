Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbZBVKHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbZBVKHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 05:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbZBVKHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 05:07:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33639 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbZBVKHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 05:07:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/9] PM: Fixes related to suspend and hibernation for 2.6.29
Date: Sun, 22 Feb 2009 11:07:30 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
References: <200902140157.40869.rjw@sisk.pl> <20090221194807.GA13114@suse.de> <alpine.LFD.2.00.0902211417401.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902211417401.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902221107.32046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 February 2009, Linus Torvalds wrote:
> 
> On Sat, 21 Feb 2009, Greg KH wrote:
> > 
> > Ok, so, Len, are you willing to send these to Linus this week?
> 
> I took them all, and added both of you to the cc, so if/when things break 
> and get bisected to this series, both of you should be cc'd on the 
> discussion.

Thanks Linus! :-)

Rafael
