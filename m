Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYCLW0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYCLW0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYCLWZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:25:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44341 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYCLWZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:25:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chr <chunkeey@web.de>
Subject: Re: 2.6.25-rc5-git2: Reported regressions from 2.6.24
Date: Wed, 12 Mar 2008 23:24:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Jike Song" <albcamus@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803120141.51844.rjw@sisk.pl> <200803121308.27662.chunkeey@web.de>
In-Reply-To: <200803121308.27662.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803122324.55143.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of March 2008, Chr wrote:
> On Wednesday 12 March 2008 01:41:51 Rafael J. Wysocki wrote:
> >
> > This message contains a list of some regressions from 2.6.24 reported since
> > 2.6.25-rc1 was released, for which there are no fixes in the mainline I
> > know of.  If any of them have been fixed already, please let me know.
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10228
> > Subject		: endless loop in native_flush_tlb_others in smp_64.c
> > Submitter	: Chr <chunkeey@web.de>
> > Date		: 2008-03-10 23:16 (3 days old)
> > References	: http://lkml.org/lkml/2008/3/10/333
> > Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> >
> My bug report is a "dup" from that one:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
> Subject		: INFO: task mount:11202 blocked for more than 120 seconds
> Submitter	: Christian Kujau <lists@nerdbynature.de>
> Date		: 2008-03-07 21:32 (6 days old)
> References	: http://lkml.org/lkml/2008/3/7/308
> 		  http://lkml.org/lkml/2008/3/9/186
> Handled-By	: David Chinner <dgc@sgi.com>

Updated accordingly.

Thanks,
Rafael
