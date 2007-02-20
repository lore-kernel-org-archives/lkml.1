Return-Path: <linux-kernel-owner+w=401wt.eu-S965075AbXBTPjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075AbXBTPjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965077AbXBTPjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:39:32 -0500
Received: from ns.firmix.at ([62.141.48.66]:45379 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075AbXBTPjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:39:31 -0500
Subject: Re: GPL vs non-GPL device drivers
From: Bernd Petrovitsch <bernd@firmix.at>
To: Valdis.Kletnieks@vt.edu
Cc: v j <vj.linux@gmail.com>, davids@webmaster.com, trent.waddington@gmail.com,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
In-Reply-To: <200702201514.l1KFEVIE023344@turing-police.cc.vt.edu>
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
	 <9b3a62ab0702192119l1bf9a284la93c9d1f01638ca4@mail.gmail.com>
	 <1171969251.12262.16.camel@tara.firmix.at>
	 <200702201514.l1KFEVIE023344@turing-police.cc.vt.edu>
Content-Type: text/plain
Organization: Firmix software GmbH
Date: Tue, 20 Feb 2007 16:39:17 +0100
Message-Id: <1171985957.23390.19.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.417 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.417 required=5
X-Spam-Score: -2.417 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 10:14 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 20 Feb 2007 12:00:51 +0100, Bernd Petrovitsch said:
> > Flame bait alert:
> > I heard a talk from an Austrian lawyer an according to his believes (and
> > I don't know if he is the only one or if there lots of) one must see
> > from the "users" view if the GPL spreads over or not (and the usual
> > technical terms like "linking" are basically irrelevant).
> > E.g.:
> > - You are distributing an application which links against a GPL-library.
> > If you provide a link and the user/customer has to get and install that
> > library, your application can have any license you wish.
> > - If you distribute an application and it installs automatically a
> > library (e.g. from the CD where your application is installed), your
> > applications license must "fit" wit the library license.
> 
> So tell me - if RedHat distributes a non-GPL program that uses a GPL
> library that is included as part of the distribution, but *not* one that's
> usually installed, which rules apply?

I'm well aware that there are (probably lots of) contradictions with
this "idea".
IANAL and we must ask that lawyer actually for this. And he will
probasbly do not understand the question since he very probably doesn't
know all the usual software distribution methods.

> Even better - does this mean that I can *intentionally* bypass the licensing by
> including a installer script that removed a problematic library, and then
> forces the user to re-install it?

A good question which belongs in the same category as above.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

