Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbXDOAHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbXDOAHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 20:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXDOAHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 20:07:50 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54381 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXDOAHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 20:07:49 -0400
X-Originating-Ip: 24.6.145.253
Date: Sat, 14 Apr 2007 20:06:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Ian McDonald <ian.mcdonald@jandi.co.nz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: {Spam?} Re: {Spam?} [PATCH] NET: Remove obsolete traffic shaper code.
In-Reply-To: <5640c7e00704141646k44334de9g99dc509bf96bac5f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704141959190.22316@localhost.localdomain>
References: <Pine.LNX.4.64.0704141925310.22138@localhost.localdomain>
 <5640c7e00704141646k44334de9g99dc509bf96bac5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: spam, SORBS-DUL,
	SpamAssassin (not cached, score=-12.808, required 5,
	ALL_TRUSTED -1.80, BAYES_00 -15.00, RCVD_IN_NJABL_DUL 1.95,
	RCVD_IN_SORBS_DUL 2.05)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(i'm betting that the mail server i use back in canada is going to tag
this yet again with "{Spam?}" since i'm in california at the moment
and i'll just bet it's freaking out seeing stuff coming from a totally
unknown IP address.  i've already sent an email to the admins about
this.  sorry.)

On Sun, 15 Apr 2007, Ian McDonald wrote:

> On 4/15/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> >
> > Remove the obsolete code for the traffic shaper.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> Apart from the merits of removing this which I can't comment on, I
> thought the usual procedure was to place a removal in
> Documentation/feature-removal-schedule.txt to notify people of what
> is going to be removed. Then wait the period you determine there and
> then remove.

in fact, according to this:

http://lkml.org/lkml/2006/1/13/139

that notice was put in the feature removal file well over a year ago,
during 2.6.15.  so that would seem to be more than adequate time for
everyone to prepare for it.  but it must have been deleted from that
file since then as well.

i probably should have mentioned that in my initial posting.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
