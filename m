Return-Path: <linux-kernel-owner+w=401wt.eu-S1759099AbXF1NsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbXF1NsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbXF1Nr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:47:57 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45422 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751996AbXF1Nr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:47:56 -0400
Date: Thu, 28 Jun 2007 08:50:01 -0500
From: "Bill O'Donnell" <billodo@sgi.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: David Miller <davem@davemloft.net>, crispin@novell.com,
       seanlkml@sympatico.ca, bunk@stusta.de, akpm@linux-foundation.org,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070628135001.GA11666@sgi.com>
References: <20070627.160535.71552808.davem@davemloft.net> <350078.43404.qm@web36601.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <350078.43404.qm@web36601.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 05:27:17PM -0700, Casey Schaufler wrote:
| 
| --- David Miller <davem@davemloft.net> wrote:
| 
| > From: Crispin Cowan <crispin@novell.com>
| > Date: Wed, 27 Jun 2007 15:46:57 -0700
| > 
| > > But we do not want to prevent other people from using SELinux if it
| > > suits them. Linux is about choice, and that is especially vital in
| > > security. As Linus himself observed when LSM was started, there are a
| > > lot of security models, they have various strengths and weaknesses, and
| > > often are not compatible with each other. That is why it is important
| > > that LSM persist, that SELinux not be the only in-tree user of LSM, and
| > > why we think AppArmor should be included upstream, so that non-SUSE
| > > users can also use AppArmor if it suits them.
| > 
| > Anyone can apply the apparmour patch to their tree, they get the
| > choice that way.  Nobody is currently prevented from using apparmour
| > if they want to, any such suggestion is pure rubbish.
| 
| The exact same argument was made prior to SELinux going upstream.
| Look, if you can't be right, try at least to be original.
| 
| > It is even more incredulious to imply that just by having apparmour
| > in the upstream kernel all the userland bits will magically appear
| > on every user's distribution.
| 
| Just like all the SELinux userland magically appeared in everyone's
| distribution? Nope, didn't happen.
| 
| > Give me a break.
| 
| No. You are out of line and spewing ignorance.

Please.
I really wish this thread would stick to the technical matter and 
dispense with the infernile sniping on one hand and stroking of
egos on the other.  Sheesh - some of us are actually trying to glean
something useful from all of this.

| 
| > What you get by the code going into the upstream kernel tree is that
| > it a) adds some pseudo legitimacy to AppArmour (which I don't
| > personally think is warranted) and b) gets the work of keeping
| > apparmour working with upstream largely off of your back and in the
| > hands of the upstream community.
| 
| Duh. Those are pretty much the reasons anyone goes through the
| trouble of getting anything upstream.
| 
| > Neither of those are reasons why something should go into the tree.
| 
| They reflect the corporate reality of the open source community.
| If you're going to go down the "open source isn't for money"
| rathole please take it elsewhere. I've heard the arguments so many
| times I can sing them to the tune of "Lady Madonna".
| 
| > Frankly I think AppArmour is a joke,
| 
| "SELinux, AppArmor, and Hilary Clinton walk into a bar ..."

Yawn.  Not funny. See above comment.

| > and all of this integration with
| > LSM business is just a face saving effort, nothing more.  And saving
| > face is not, and has never been, a reason for something to be put into
| > the upstream tree.
| 
| Believe what you will. Crispin has been working with LSM from the
| inception those many years ago. He's been working on getting this
| module in for over a year. If you don't like his module go write
| your own and put him out of business.

Now this is getting really boring.  See above comment.
Can't we just stay on point?

-- 
Bill O'Donnell
SGI
billodo@sgi.com
