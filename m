Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXJYBDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXJYBDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXJYBDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:03:38 -0400
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:34705 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751942AbXJYBDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:03:37 -0400
X-YMail-OSG: 6mtJxEEVM1n.noVOvxaFDXUzIVl9Hkrtgifmp_UiQRwa7i7ozuuwqio3TcwEyluINx3KYLQmQuHHsXNY1xZnaBwp2OdQYGArvWq6kRDzbcWKkdGPuUI-
X-RocketYMMF: rancidfat
Date: Wed, 24 Oct 2007 18:03:37 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.0.999.0710241636010.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <64482.42947.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 25 Oct 2007, Adrian Bunk wrote:
> > 
> > What I'm giving you is "Linus has decreed there can be LSMs other than 
> > SELinux."
> > 
> > Getting LSMs included should no longer be harder than for other 
> > parts of the kernel.
> 
> Well, despite my heart-felt feelings that we should support different 
> people in trying out different things, one of the issues is also that I'm 
> obviously not myself a security person. I can "decree" all I want, but in 
> the end, I really want the people *involved* to merge security stuff. 
> 
> Right now Chris Wrigt is the documented maintainer for LSM, and quite 
> frankly, I do not want to take it over. I really really really hope that
> people that are interested in security can work this thing out, and my 
> only requirement is that it doesn't end up being any kind of force-feeding 
> of opinions and ideas, since clearly there is tons of room for 
> disagreement in the area..
> 
> Do other people want to stand up and be "LSM maintainers" in the sense 
> that they also end up being informed members who can also stand up for new 
> modules and help merge them, rather than just push the existing one(s)? 
> Chris? Casey? Crispin?

Count me in.

> [ Ie there's the "core LSM hooks" on one side, but there's also the "what 
>   modules make any sense at all to merge?" on the other, and I really 
>   don't have the expertise to make any sensible judgements except for the 
>   pure "process" judgement that we should not hardcode things to just one 
>   module! ]
> 
> 		Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
