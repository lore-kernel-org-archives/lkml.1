Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbXFUUPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbXFUUPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbXFUUPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:15:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbXFUUPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:15:40 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070621180029.GR21478@ftp.linux.org.uk>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 17:15:03 -0300
In-Reply-To: <20070621180029.GR21478@ftp.linux.org.uk> (Al Viro's message of "Thu\, 21 Jun 2007 19\:00\:29 +0100")
Message-ID: <orhcp1jc8o.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, Al Viro <viro@ftp.linux.org.uk> wrote:

> On Thu, Jun 21, 2007 at 06:39:07AM -0300, Alexandre Oliva wrote:

>> - the kernel Linux could use code from GPLv3 projects

> ... and inherit GPLv3 additional restrictions.  No.

Respecting the wishes of the author of that code.  Are you suggesting
they should not be respected?

Anyone who's not happy about it can still take that portion out,
unless you accept changes that make this nearly impossible, which I
suppose you wouldn't given how strongly you feel about this.

Without this provision, you wouldn't be able to use the code in the
first place, so I don't perceive any loss for anyone.  Do you?

>> - GPLv3 projects could use code from Linux

> Oh, rapture!  How could one object against such a glorious outcome?

Exactly ;-)

Two-way cooperation.  I'm told that's good.  I was told this was even
desirable.

I can see that one-way cooperation could be perceived as unfair, even
if permissions granted by GPLv3 are all granted by GPLv2 as well.

>> - each copyright holder would still get to enforce the terms s/he
>> chose for his/her own code

> ... except for that pesky "no added restrictions" part, but hey, who
> cares?

But see, nobody would be adding restrictions to *your* code.  You'd
only be enabling mutual cooperation with projects whose authors
weren't happy about restrictions some licensees could impose on others
(including the authors themselves).

>> If you were to permit compatibility with GPLv3+ (rather than GPLv3),
>> would you constrain it?  Would something like:
>> 
>> as long as the later version grants each licensee the same
>> permissions as GPLv2, except for constraining permissions that would
>> enable one licensee to deny other licensees the exercise of the
>> permissions granted by both licenses

> ... because it's For The Benefit Of User Freedoms!!!

It is either way.  Do you deny that tivoization also benefits one
user/licensee?  And in detriment of others, while at that?

> No.  Permission denied.

Your opinion is duly noted.  Thanks.

> If somebody wants to dual-license *others* code,

This is not about dual licensing at all, and this is not about others
code.  This is a decision you would have to make in order to enable
cooperation between projects.

If you don't want to make this decision, that's fine.  Nobody can be
forced to cooperate.  This works in both directions.

Don't try to frame those who want to respect and defend users'
freedoms as uncooperative.  This is *your* decision, and your decision
alone.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
