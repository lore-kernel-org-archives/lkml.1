Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYGPKIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYGPKIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbYGPKHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:07:52 -0400
Received: from r00tworld.com ([212.85.137.21]:56231 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbYGPKHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:07:52 -0400
From: pageexec@freemail.hu
To: Gabor Gombas <gombasg@sztaki.hu>
Date: Wed, 16 Jul 2008 12:04:26 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Tiago Assumpcao <tiago@assumpcao.org>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Message-ID: <487DE3CA.5722.1ECB175D@pageexec.freemail.hu>
In-reply-to: <20080716093500.GC11485@boogie.lpds.sztaki.hu>
References: <20080716031319.GA7558@kroah.com>, <487DD51F.15884.1E91CBD4@pageexec.freemail.hu>, <20080716093500.GC11485@boogie.lpds.sztaki.hu>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 12:07:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jul 2008 at 11:35, Gabor Gombas wrote:

> On Wed, Jul 16, 2008 at 11:01:51AM +0200, pageexec@freemail.hu wrote:
> 
> > very good example of how you actually do *not* do what you claim. find me
> > the word 'security' in your announcement. it's not there. amazing, isn't it.
> > despite what your fellow -stable maintainer claimed *he* would at least do
> > (and regularly tries to do so in fact). despite what you yourself did on
> > other occasions (remember 2.6.23.8?). what's wrong with you Greg? have you
> > not been told and proven to cover up security bugs enough times already?
> 
> Huh? Have you read the announcement? If one do not understand from the
> wording that this _is_ a security fix then he/she is stupid beyond hope.

i understand what it is, i would understand it even if it said even
less.

what does this have to do with carefully avoiding the word 'security'
on one hand and disclosing it on another? do you understand the word
'consistency' or are you 'stupid beyond hope'?

> And I see that the biggest difference between you and the kernel
> developers:

no you don't see it. you haven't even read or understood all the
discussion else you would not be making stupid claims as below:

> the kernel developers want you to _think_ whether that
> particular patch is important for you or not.

are you out of your mind? since when it is the job of users (meaning,
users of commit logs) to reverse engineer what the heck the given
commit was supposed to actually fix? do you think they don't have
better use of their time? if there is a purpose of a commit message
then it's that of informing the reader, not confusing or misleading
him.

> You on the other hand want
> to be able to mindlessly apply patches marked as "security fix"

what is mindless about applying a security fix?

> without
> any consideration about how all the other unfixed bugs can bite you.

where did i say that people should apply security fixes without
considering other, unmarked fixes? i said the exact opposite which
you would know if you had actually cared to read the thread in its
entirety.

udv,
  PaX Team

