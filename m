Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbXJ2U1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbXJ2U1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbXJ2U1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:27:25 -0400
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:28174 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753385AbXJ2U1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:27:24 -0400
X-YMail-OSG: IHgJIIQVM1nc0Hppx8Vc4u87dYT1tkho6Y0n4CHZj88f2zz3giq91kdFz3BIyOz5mgZxZ6qdNQ--
X-RocketYMMF: rancidfat
Date: Mon, 29 Oct 2007 13:27:23 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to           static interface)
To: rmeijer@xs4all.nl, Crispin Cowan <crispin@crispincowan.com>
Cc: rmeijer@xs4all.nl, casey@schaufler-ca.com,
       Chris Wright <chrisw@sous-sol.org>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <949883.45076.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Rob Meijer <capibara@xs4all.nl> wrote:


> >     * The proposal only allows a single implementation of each formal
> >       model. In theory, theory is just like practice, but in practice it
> >       is not. SMACK and SELinux follow substantially similar formal
> >       models (not exactly the same) so should we exclude one and keep
> >       the other? No, of course not, because in practice they are very
> >       different.
> 
> I would think the two may benefit from a role as described above.
> But I was thinking more in the line of new modules that may again
> implement this same model, and would thus benefit from interaction with
> this 'model maintainer' role.

The Smack development has benefited greatly from comments, suggestions,
and bug reports from members of the SELinux community. Further, I have
had no trouble whatever sharing the netlabel component with SELinux.
Audit is another matter as it requires some work to get the SELinux
dependencies out, but everyone's been receptive to proposals there.
Why on earth would I want some 'model maintainer' passing judgements
on my work in progress? The only thing I can imagine a 'model
maintainer' doing is obstructing innovation. Unless it was me, of
course. Linus is right, you know.


Casey Schaufler
casey@schaufler-ca.com
