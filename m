Return-Path: <linux-kernel-owner+w=401wt.eu-S1763343AbXGFMv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763343AbXGFMv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763330AbXGFMvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:51:46 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:63108 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763184AbXGFMvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:51:43 -0400
Date: Fri, 6 Jul 2007 14:51:37 +0200
From: DervishD <lkml@dervishd.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Nix <nix@esperi.org.uk>, Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070706125137.GA1518@DervishD>
Mail-Followup-To: Bodo Eggert <7eggert@gmx.de>,
	Nix <nix@esperi.org.uk>, Karel Zak <kzak@redhat.com>,
	List util-linux-ng <util-linux-ng@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <8CYT9-4Ou-23@gated-at.bofh.it> <8Dh9k-8lT-3@gated-at.bofh.it> <8DtDz-3xC-15@gated-at.bofh.it> <E1I6SfW-0002XG-AM@be1.lrz> <20070705192002.GB11204@DervishD> <Pine.LNX.4.58.0707061406090.2241@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.58.0707061406090.2241@be1.lrz>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Bodo :)

 * Bodo Eggert <7eggert@gmx.de> dixit:
> On Thu, 5 Jul 2007, DervishD wrote:
> >  * Bodo Eggert <7eggert@gmx.de> dixit:
> 
> > > Standardisation is good, but autotools (as they are used) usurally isn't.
> > 
> >     Usually, by picking other's project configure.in and tweak blindly.
> 
> If it were that easy to write a correct automake script, people would do 
> that. Wouldn't they?

    That's exactly what I meant! People don't write good autotools
scripts because it's difficult to learn autoconf and automake and it's
almost impossible to master. It's more or less easy to write an autoconf
script, but it's not so easy to make it right, powerful and to honor
every configure switch, etc...

> > > Configuring the build of an autotools program is harder than nescensary;
> > > if it used a config file, you could easily save it somewhere while adding
> > > comments on how and why you did *that* choice, and you could possibly
> > > use a set of default configs which you'd just include.
> > 
> >     Looks like CMake...
> 
> Obviously something I should look at.

    Me too. I've learned a bit of CMake because I have my own building
system ("configure" compatible from the point of view of the packager),
but instead of adding new features I think I'm going to switch to CMake
fully.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
