Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYGTLBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYGTLBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbYGTLBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:01:24 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:45897 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192AbYGTLBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:01:22 -0400
Date: Sun, 20 Jul 2008 13:01:19 +0200
From: Helge Hafting <helgehaf@aitel.hist.no>
To: Cheradenine Zakalwe <sc.contact@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The state of linux security
Message-ID: <20080720110119.GA9175@aitel.hist.no>
References: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 04:05:07PM +0000, Cheradenine Zakalwe wrote:
> Right, for a start, if I was a professor at university I'd much rather
> some "smart" students crashed 100 boxes a day for a year than one
> owned several servers.  In any case, it seems absurd that anybody
> looking for security holes to either subvert or crash systems would be
> deterred by the lack of security commit messages.  They already know
> what they are looking for.  On the other hand, there has to be some
> metrics available for normal people to make an informed decision about
> the relative security of linux and the likely hood that smart people
> are able to cause a bit of mindless vandalism or get up to much worse.
> 
> Your hand waving and obfuscation simply do not wash.  The bugs being
> talked about are not just any bugs.  They have their own commercial
> value because they can allow the complete subversion of your systems.

Bear in mind that top linux development does not happen in a
corporation. So "commercial value" is a complete non-issue.
Corporations like RedHat and SUSE care about this though. If
you want guarantees and documented security - that is where you
want to go. Not to the kernel mailing list. 

> This (for most people I'd guess) is far more dangerous than simply
> having their computers crash. 

Sure. And kernel developers don't want their machines
taken over either. So they do fix security bugs.

> This business of passing the buck onto vendors is also absurd.  If

Not absurd if you think about it. Most linux developers don't develop
linux for money - they don't have customers - so customers have *no*
hold over them at all. Vendors are the ones who have to care, so they
do that. 

Still, linux security is good for a different reason - there is prestige
in making linux good, and so developers strive for that. Also,
security-concerned vendors are always welcome to bring security
patches...



> security is not built into your development mindset and models from

Each developer has the mindset "what I want from linux". That's
what you get from such a loosely organized effort. But many actually
wants security, so you get that even without a clear policy.

> One more thing I'd like to throw out there on the issue of
> accountability is this:  How do I know that some developers have not
> been paid to specifically introduce some obscure security flaw?  Given
> that such subversions happen frequently in every other field of human
> endeavour where potential profit is involved, this is not beyond the
> realms of possibility. 

This is much harder to do in linux, than in a closed-source system. If I
bribe a key microsoft developer to put in a backdoor, then nobody notice
until I exploit it - for the source code is a trade secret.

If i bribe a linux developer to put in a backdoor, then this developer's
patch will likely be rejected by the upstream maintainer or Linus, for
containing a griveous scurity flaw. And if it isn't caught immediately,
then it will still be open for all to see.

Also, bribing a key linux developer is probably much harder, since
they work for pride instead of money. Someone getting caught
would likely never be trusted in open-source development again,
a dramatic loss for such a person.


> If the attitudes of the people at the top of linux development don't
> change this is the end of the linux experiment for me and i'm sure
> many other people.  The percieved benifits of transparancy, openness
> and cost will have been completely smashed for the vast majority of
> users.  This is not something to be taken lightly.

Current attitudes has brought linux where it is today - it works very
well.

Helge Hafting

