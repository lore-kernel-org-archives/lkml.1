Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYGVIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYGVIQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYGVIQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:16:11 -0400
Received: from ns.firmix.at ([62.141.48.66]:2828 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbYGVIQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:16:09 -0400
Subject: Re: Please add ZFS support (from GPL sources)
From: Bernd Petrovitsch <bernd@firmix.at>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Fred ." <eldmannen@gmail.com>, Kevin Winchester <kjwinchester@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080722074453.GA25205@infradead.org>
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>
	 <487FA143.9010109@garzik.org> <20080720105724.GA8921@infradead.org>
	 <d1af83620807200535s6516e3b7wd16233391e5e8533@mail.gmail.com>
	 <20080721072801.GA6115@infradead.org>
	 <d1af83620807210439r6b8fa39bu4f3fd76c86aa548d@mail.gmail.com>
	 <f188924b0807210723v3a35de9fgc1565811a0597833@mail.gmail.com>
	 <d1af83620807210740vfef575bp73832fd95d803850@mail.gmail.com>
	 <1216651854.2657.35.camel@spike.firmix.at>
	 <20080722074453.GA25205@infradead.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 22 Jul 2008 10:15:58 +0200
Message-Id: <1216714558.14148.31.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.275 () AWL,BAYES_00,FORGED_RCVD_HELO,SARE_SUB_OBFU_OTHER,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.275 required=5
X-Spam-Score: -2.275 () AWL,BAYES_00,FORGED_RCVD_HELO,SARE_SUB_OBFU_OTHER,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-22 at 03:44 -0400, Christoph Hellwig wrote:
> On Mon, Jul 21, 2008 at 04:50:54PM +0200, Bernd Petrovitsch wrote:
> > On Mon, 2008-07-21 at 11:40 -0300, Kevin Winchester wrote:
> > [....]
> > > > But it may be covered by patents by Sun. So maybe not allowed make an
> > > > implementation. :(
> > > > Maybe you should consult SFLC (Software Freedom Law Center) first or something.

That was quoted from a reply since that didn't make it in my mailbox
(and perhaps on the list as the "Cc: added" suggests).
 
> > Since basically *you* wanted that feature in the first place (and for
> > whatever reason do not even start to work on it),
> 
> Either you or I have lost track here.  Fred without a lastname asked for
> ZFS support based on the grub code, and never replied again in this

ACK.
To summarize:
- First he requests that someone else implements/ports/... something
   (for whatever reason) to GPL/the kernel/....
- Then some advice, hints and a kind soul offers help (no problem for
   me).
- And then the original requester comes up with "you might have check
   for potential patent problems" on technical mailinglist (at least
most
   of the time;-).

The following open questions for me were/are:
- Why is *that* important for the original requester?
- Why didn't he do his (legal) homework before or simply ignore that or
   - at  least - stated it in the original mail[0].
- Which aspect/unresolved problem/potential problem will come next?

> thread.  Kevin volunteered to work on it.

I have no problem with that.
Heck, personally I don't have a problem if someone takes the ZFS source
and makes a (completely separate) GPLv2 patch to use it in kernel-space
(and not "only" with FUSE).

The legal implications?
Apart from the generic lawyer answer "it depends on the circumstances",
I don't know.

	Bernd

[0]: What's the English phrase for the German "Salami-Taktik"? You don't
         come up with the whole problem at once but try to solve it in
small
         steps luring the problem solver (which gets only the next step
         presented) into it so that s/he can't stop (for whatever reason
-
         it is heavily used in the commercial world).
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


