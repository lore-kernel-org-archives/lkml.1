Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbYGPPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbYGPPpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbYGPPp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:45:26 -0400
Received: from r00tworld.com ([212.85.137.21]:35201 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbYGPPpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:45:25 -0400
From: pageexec@freemail.hu
To: Greg KH <greg@kroah.com>
Date: Wed, 16 Jul 2008 17:43:15 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Tiago Assumpcao <tiago@assumpcao.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487E3333.30028.20014B8F@pageexec.freemail.hu>
In-reply-to: <20080716144347.GB13253@kroah.com>
References: <20080716031319.GA7558@kroah.com>, <487DD51F.15884.1E91CBD4@pageexec.freemail.hu>, <20080716144347.GB13253@kroah.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 17:44:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jul 2008 at 7:43, Greg KH wrote:

> On Wed, Jul 16, 2008 at 11:01:51AM +0200, pageexec@freemail.hu wrote:
> > On 15 Jul 2008 at 20:13, Greg KH wrote:
> > 
> > very good example of how you actually do *not* do what you claim. find me
> > the word 'security' in your announcement. it's not there. amazing, isn't it.
> 
> No, it was a consious decision to do just to piss you off, glad to see
> it worked :)
> 
> Come on, give me a break, Tiago asked that we do releases as soon as we
> know about a security problem.  2.6.25.11 was released because of this,
> and all users were told to upgrade.  Is the fact that I add the magic
> word "security" in a sentance in the email some specific requirement
> that will make you happy?

it's not about making me happy Greg. i can figure these things out for
myself, i do *not* need your help in that. there're many users however
who rely on your providing accurate information. announcing a security
fix as such is the proper thing to do, i can't imagine how you guys can
dance around that simple fact for so long. just look at what your own
employer does with security bugs, if they see it fit to mark them as
such, how can you possibly argue that you're somehow acting in good
faith when you cover them up? will you next tell your corporate bosses
that they're bloody idiots that can't tell a bug from a bug and should
just omit the word 'security' altogether from future announcements? i
didn't think so either.

> Take a look at the words I used, if someone can't determine if they
> should upgrade or not based on that,

your carefully chosen words are *wrong* in fact. exploiting local bugs
has nothing to do with having untrusted users in the age of client side
exploits. due to your completely mischaracterized description, individual
home users may very well feel that they do not need to upgrade, to the
delight of the next malware owning their browser. you can congratulate
yourself Greg, you successfully misled a whole class of users.

> then they need to rely on a company
> to provide updates for them, and not be running their own kernels
> because they really have no clue about system management.

you conveniently failed to respond to the rest of my mail where i showed
that Chris Wright, heck, even yourself did announce security fixes as such
in the past. how do you explain that?

> Bah, what a joke.

and i thought i was the one getting pissed ;).
cheer up,
  PaX Team

