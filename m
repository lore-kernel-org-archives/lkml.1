Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbXJXW6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbXJXW6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXJXW6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:58:05 -0400
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:39305 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755874AbXJXW6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:58:03 -0400
X-YMail-OSG: 5hFqyZkVM1ngE0LSgfDDNbvbISt5heLxtsaJNiW5R8Pud.JZ99W0nFwuWtE2Da1GEQA_Qmy4HA--
X-RocketYMMF: rancidfat
Date: Wed, 24 Oct 2007 15:58:02 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
To: Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20071024223124.GI30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <446110.89443.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Adrian Bunk <bunk@kernel.org> wrote:

> ...
> 
> There are other points in this thread that might or might not warrant 
> making LSM modular again, but even though it might sound harsh breaking 
> external modules and thereby making people aware that their code should 
> get into the kernel is IMHO a positive point.

Those proposing LSM modules over the past couple years have
been treated most harshly. I have personally taken the least
flak of anyone on my proposal, and at that there have been
times where I felt like pulling out the #5 clue stick and
taking a few swings. It's no wonder that people are afraid
to suggest a module. I didn't do it until I had combed through
the archives and prepared answers for the most common attacks.
I hope that Smack moving forward will defuse some of the bad
vibes that have clouded the LSM for so long. I don't blame
anyone who kept their module to themself given the hostility
which even successful products have encountered.

And don't give me the old "LKML is a tough crowd" feldercarb.
Security modules have been much worse. Innovation, even in
security, is a good thing and treating people harshly, even
"for their own good", is an impediment to innovation.


Casey Schaufler
casey@schaufler-ca.com
