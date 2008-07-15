Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYGOIdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYGOIdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYGOIdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:33:07 -0400
Received: from ns.firmix.at ([62.141.48.66]:6423 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377AbYGOIdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:33:04 -0400
Subject: Re: From 2.4 to 2.6 to 2.7?
From: Bernd Petrovitsch <bernd@firmix.at>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>
	 <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
	 <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com>
	 <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 15 Jul 2008 10:29:30 +0200
Message-Id: <1216110570.12102.45.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.342 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.342 required=5
X-Spam-Score: -2.342 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 19:47 -0700, Linus Torvalds wrote:
> On Mon, 14 Jul 2008, Stoyan Gaydarov wrote:
> > > For example, I don't see any individual feature that would merit a jump
> > > from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version jumps
> > > should be done by a time-based model too - matching how we actually do
> > > releases anyway.
> >
> > Does it have to be even numbers only?
> 
> No. But the even/odd thing is still so fresh in peoples memory (despite us 
> not having used it for years), and I think some projects aped us on it, so 
> if I didn't change the numbering setup, but just wanted to reset the minor 
> number, I'd probably jump from 2.6 to 2.8 just for historical reasons.

ACK. "Normal" users (and especially average journalists where most
"normal" users get their knowledge from) tend to know of "odd Linux
kernel version are development" (and will probably report it wrongly
that way if "2.7 is released").
Perhaps they learn the new model if 2.7 will never have existed and
people asked about.

[...]
> Anyway, I have to say that I personally don't have any hugely strong 
> opinions on the numbering. I suspect others do, though, and I'm almost 
> certain that this is an absolutely _perfect_ "bikeshed-painting" subject 

ACK, probably the best. But others are surely better in proposing
beautiful colors.

[....]

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


