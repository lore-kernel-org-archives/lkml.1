Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbXF1A12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbXF1A12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 20:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbXF1A1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 20:27:19 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:22360 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754706AbXF1A1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 20:27:18 -0400
X-YMail-OSG: tkaKsD0VM1m7t95gBPirbmcVdNZPvWmbtHI.cxsXIKmQvx5jiZw1mzDYKeUIv0C8Hw63Mgu98A--
X-RocketYMMF: rancidfat
Date: Wed, 27 Jun 2007 17:27:17 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 00/44] AppArmor security module overview
To: David Miller <davem@davemloft.net>, crispin@novell.com
Cc: seanlkml@sympatico.ca, bunk@stusta.de, akpm@linux-foundation.org,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20070627.160535.71552808.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <350078.43404.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Miller <davem@davemloft.net> wrote:

> From: Crispin Cowan <crispin@novell.com>
> Date: Wed, 27 Jun 2007 15:46:57 -0700
> 
> > But we do not want to prevent other people from using SELinux if it
> > suits them. Linux is about choice, and that is especially vital in
> > security. As Linus himself observed when LSM was started, there are a
> > lot of security models, they have various strengths and weaknesses, and
> > often are not compatible with each other. That is why it is important
> > that LSM persist, that SELinux not be the only in-tree user of LSM, and
> > why we think AppArmor should be included upstream, so that non-SUSE
> > users can also use AppArmor if it suits them.
> 
> Anyone can apply the apparmour patch to their tree, they get the
> choice that way.  Nobody is currently prevented from using apparmour
> if they want to, any such suggestion is pure rubbish.

The exact same argument was made prior to SELinux going upstream.
Look, if you can't be right, try at least to be original.

> It is even more incredulious to imply that just by having apparmour
> in the upstream kernel all the userland bits will magically appear
> on every user's distribution.

Just like all the SELinux userland magically appeared in everyone's
distribution? Nope, didn't happen.

> Give me a break.

No. You are out of line and spewing ignorance.

> What you get by the code going into the upstream kernel tree is that
> it a) adds some pseudo legitimacy to AppArmour (which I don't
> personally think is warranted) and b) gets the work of keeping
> apparmour working with upstream largely off of your back and in the
> hands of the upstream community.

Duh. Those are pretty much the reasons anyone goes through the
trouble of getting anything upstream.

> Neither of those are reasons why something should go into the tree.

They reflect the corporate reality of the open source community.
If you're going to go down the "open source isn't for money"
rathole please take it elsewhere. I've heard the arguments so many
times I can sing them to the tune of "Lady Madonna".

> Frankly I think AppArmour is a joke,

"SELinux, AppArmor, and Hilary Clinton walk into a bar ..."

> and all of this integration with
> LSM business is just a face saving effort, nothing more.  And saving
> face is not, and has never been, a reason for something to be put into
> the upstream tree.

Believe what you will. Crispin has been working with LSM from the
inception those many years ago. He's been working on getting this
module in for over a year. If you don't like his module go write
your own and put him out of business.


Casey Schaufler
casey@schaufler-ca.com
