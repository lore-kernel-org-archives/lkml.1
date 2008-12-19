Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYLSA2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYLSA2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYLSA2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:28:23 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:60569 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYLSA2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:28:22 -0500
From: Junio C Hamano <gitster@pobox.com>
To: paulmck@linux.vnet.ibm.com
Cc: Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
 <alpine.DEB.1.00.0812121952320.5873@eeepc-johanness>
 <20081219000218.GA23990@linux.vnet.ibm.com>
Date: Thu, 18 Dec 2008 16:28:11 -0800
In-Reply-To: <20081219000218.GA23990@linux.vnet.ibm.com> (Paul E. McKenney's
 message of "Thu, 18 Dec 2008 16:02:18 -0800")
Message-ID: <7vabatf1pg.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: F07251FE-CD63-11DD-8A9B-5720C92D7133-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Fri, Dec 12, 2008 at 07:57:38PM +0100, Johannes Schindelin wrote:
> ...
>> I am sure we want to have something like that in git.git.
>
> So am I.  Except that I am not being sarcastic.  ;-)

Hmm, but we seem to already have too many intro-to-git documents in tree.
Perhaps good points in the document can be used to augment or replace
parts of existing documents?  For example, which part of the new
documentation would have helped you avoid the pain you mentioned below...

> In particular, David's guide was quite helpful to me.  It would have been
> even more helpful had it existed when I first tried (unsuccessfully)
> to use GIT.  In particular, GIT's requirement that I tell it about new
> versions of existing files (either with "git add" or "git commit -a")
> was extremely counter-intuitive, and caused me no end of pain.

... and which part of the existing user manual or tutorial should have
talked about it to help you?

> But my experience is that git is at best an acquired taste for those of
> us who grew up with traditional source-code control systems.  Such
> people will benefit greatly from a git-haters guide,...

"Acquired taste" is a much nicer and more diplomatic way to say the same
thing as what Linus often refers as "unlearning the braindamage inflicted
by years of using CVS." ;-)

> ..., and git's user
> population will grow as a result.

I do not think it constitutes any basis for judging the merit of having
the document in git.git tree.  The world domination is not our goal, but
it may come as a mere side effect of being the best in the business.
