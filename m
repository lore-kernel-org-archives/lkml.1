Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbXFUTpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbXFUTpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXFUTpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:45:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbXFUTpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:45:19 -0400
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKKEIFEKAC.davids@webmaster.com>
	<orodjfkzjt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070620140101.GU10008@csclub.uwaterloo.ca>
	<or1wg6uz53.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070621150022.GY10008@csclub.uwaterloo.ca>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 16:45:05 -0300
In-Reply-To: <20070621150022.GY10008@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Thu\, 21 Jun 2007 11\:00\:22 -0400")
Message-ID: <or7ipxks72.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> Apparently the only restrictions ever permitted are the ones the FSF
> thinks of.

Where does this nonsensical idea come from?  How does it follow that,
from FSF offering a licensing option to authors, you conclude that
nobody could ever establish whatever other restrictions they liked?

> So really what the GPL v3 wants to have is to make sure that the user
> can reproduce from the sources a bit for bit identical copy of the
> binaries?

No, this is not enough to enable someone to adapt the software to
one's own needs.

> Too bad compilers that put time stamps and such into the
> binary would make that imposible.

This would be the copyright author imposing such a restriction, not
the software distributor.

> I don't think there is any way that can be written into the GPL that
> can prevent all loop holes for how to make signed binaries.

Which is one possible reason to explain why the FSF switched to the
'Installation Information' approach.

> There doesn't have to be an agreement.  The software company could just
> release specs for a hardware design and let others freely go and build
> them from that design.

Aah, so the software company has designed a mechanism to restrict
users' freedoms, and is just leaving it up to third parties to
complete the implementation?  I think these design documents could be
used in a court to prove intent to impose restrictions on the users,
but IANAL.

>> However, if there's no such agreement, if the copyright holder has no
>> copyright claims over the hardware or works shipped in it, there's
>> nothing the copyright holder can do about it, and that's probably how
>> it should be, since a copyright license (!= contract) can't possibly
>> prohibit people from creating hardware limited in function, it can
>> only tell people that, in order for them to have permission to modify
>> or distribute the covered work, they must abide by certain conditions.
>> And if they don't want to abide by the conditions, and they don't
>> manage to obtain a license from the copyright holders that doesn't
>> impose conditions they can't accept, they just can't modify or
>> distribute the work.

> But if the hardware ships with only code that simply waits for the user
> to provide some code for it to isntall (which has to be signed in a way
> the hardware likes), then the hardware has nothing to do with the
> license of the software.

Correct.  That's pretty much what I said, isn't it?

> I hope no one does this, but I still don't see how the GPLv3 draft deals
> with this case, or even how it could deal with it.

It doesn't, and it probably shouldn't.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
