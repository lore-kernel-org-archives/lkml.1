Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXFTOBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXFTOBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXFTOBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:01:04 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:58273 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbXFTOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:01:03 -0400
Date: Wed, 20 Jun 2007 10:01:01 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070620140101.GU10008@csclub.uwaterloo.ca>
References: <MDEHLPKNGKAHNMBLJOLKKEIFEKAC.davids@webmaster.com> <orodjfkzjt.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orodjfkzjt.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 12:52:38AM -0300, Alexandre Oliva wrote:
> What it does is impose conditions for whoever wants to distribute the
> software.  And GPLv3 makes it explicit that one such condition is to
> permit the user to install and run modified versions of the program in
> the hardware that ships with the program.  A condition that is
> arguably already encoded in the "no further restrictions to the rights
> granted" by the license" and to the requirement for complete
> corresponding source code to accompany the binary.
> 
> That you disagree with it doesn't make you right.
> 
> But that it is within the spirit of the GPL defined by its authors
> (which is all I'm trying to show here), it is.
> 
> > The GPL (at least through version 2) is about free access to source
> > code.
> 
> Some think so, but this was GPLv1.
> 
> v2 added stuff such as:
> 
>   if a patent license would not permit royalty-free redistribution of
>   the Program by all those who receive copies directly or indirectly
>   through you, then the only way you could satisfy both it and this
>   License would be to refrain entirely from distribution of the
>   Program
> 
> Do you realize that the patent is unrelated with the program, but
> nevertheless the copyright license establishes conditions about what
> kind of patent licenses you may accept in order for you to have
> permission to distribute the program.
> 
> Why should restrictions through patents be unacceptable, but
> restrictions through hardware and software be acceptable.
> 
> Both are means to disrespect users' freedoms.

A patent prevents you from using the software in any way at all, while a
hardware restriction prevents you from using the software on that
particular hardware, but not on lots of other hardware.  Very big
difference.

> It is the duty of the FSF to defend these freedoms.  It's its public
> mission.  That's a publicly stated goal of the GPL, for anyone who
> cares to understand it, or miss it completely and then complain about
> changes in spirit.

I wouldn't call it a duty.  It is the chosen mission perhaps, but nobody
is making them do it.

> That's true.  Per the license, it's only who distributes the hardware
> to you that shouldn't impose such restrictions.

So what would happen if some company was to make software for a tivo and
released their binaries signed with some specific key, and they released
information on how to check this was signed with their key, and then
some other companies went and made tivo hardware and decided that they
would only allow code signed by the first companies key to run on it,
because that company had software which was acceptable to the
DMCA/RIAA/MPAA/etc and allowed them to get access to the hardware they
wanted to use in their box.  The second company now sells hardware to
make money, and the first company sells tv guide updates service to
people who want to use their software releases fully.

What does the GPL do now?  The software company still releases the
sources to the GPL software, but their binary releases are signed with a
key they don't give you.  They didn't provide you with any hardware, you
have to buy that from the hardware company that makes a product that
happens to run that software because it has the right bits of hardware
to record tv programs and such.  The hardware company put restrictions
on what software the box will run, although techicly the software
company that has the signing key could make lots of compatible software
for that particular locked down hardware, including vxworks or windows
based code if they chose to do so, while the hardware company just makes
hardware and decided to only allow software with the signature to run.
They didn't distribute any software, the buyer has to go get that from
the software company if they want the box to be useful (probably not a
good business plan for the majority of customers, but still possible in
theory).

> That's right.  But one of the obligations is to impose no further
> restrictions on the exercise of the rights.  What is "imposing a
> restriction"?  Installing the software in ROM isn't regarded as such,
> it's just a technical decision.  Installing the software in modifiable
> non-volatile storage, but denying the user the ability to change it,
> is regarded as imposing a restriction.  (note the "denying")  It is a
> matter of intent.
> 
> It's not because you only install say 32MB of RAM on the machine that
> you're denying the user the ability to run OOo on the machine.  But if
> you ship the computer with plenty of memory, but somehow configure the
> hardware or the operating system so as to prevent the user from
> upgrading an OOo that shipped with it, while you can still install
> that upgrade, then you're actively placing limits on the user's
> freedom WRT to that software, and an anti-tivoization clause would
> then stop you from distributing the software under these conditions.
> 
> I've never disputed that this is how they perceive it.
> 
> I've never disputed that GPLv2 serves this goal.
> 
> I still think GPLv3 serves this same goal, and better than v2.
> 
> But this is not what my participation here is about.
> 
> My participation here is about showing that GPLv3, and anti-tivozation
> in particular, don't violate the spirit of the defending users'
> freedoms WRT the covered software, such that the Free Software remains
> Free.

Well many people in the community disagrees, and you can't change their
mind on that it would seem, just as they can't change yours (or the FSFs
for that matter).  I would not be surprised to see some code forks when
the GPLv3 is finally released.

--
Len Sorensen
