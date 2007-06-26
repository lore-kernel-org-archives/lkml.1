Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbXFZPde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbXFZPde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbXFZPd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:33:27 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:63893 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842AbXFZPd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:33:26 -0400
Date: Tue, 26 Jun 2007 17:36:56 +0200
From: DervishD <lkml@dervishd.net>
To: Arne Georg Gleditsch <argggh@dolphinics.no>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Message-ID: <20070626153656.GB27438@DervishD>
Mail-Followup-To: Arne Georg Gleditsch <argggh@dolphinics.no>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
	lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706221626.39969.ak@suse.de> <20070622094429.0910c7cb.randy.dunlap@oracle.com> <200706221923.02736.ak@suse.de> <20070622132810.3c758590.randy.dunlap@oracle.com> <E1I2159-0005AH-DS@flower> <20070623104303.a186c5a8.randy.dunlap@oracle.com> <87645bhtvw.fsf@pelargir.dolphinics.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87645bhtvw.fsf@pelargir.dolphinics.no>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Arne :)

 * Arne Georg Gleditsch <argggh@dolphinics.no> dixit:
> Randy Dunlap <randy.dunlap@oracle.com> writes:
> > OTOH, you also didn't supply a patch.  If you do this, I'll be
> > glad to consider it.  If I can read it, that is.
> 
> I like bash as much as the next guy, but (to my surprise) /bin/sh on
> my current workstation is actually dash.

    You're probably using Ubuntu, am I right? I have a do-it-yourself
Linux box and my /bin/sh is dash. It is POSIX compliant, small and
lightning fast. I use as a reference shell. I have installed zsh and
bash, too, and sometimes I have to relink /bin/sh to point to /bin/bash
so certain scripts work...

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
