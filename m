Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbXFTUy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbXFTUy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbXFTUyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:54:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXFTUyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:54:20 -0400
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKKEIFEKAC.davids@webmaster.com>
	<orodjfkzjt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070620140101.GU10008@csclub.uwaterloo.ca>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Wed, 20 Jun 2007 17:52:40 -0300
In-Reply-To: <20070620140101.GU10008@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Wed\, 20 Jun 2007 10\:01\:01 -0400")
Message-ID: <or1wg6uz53.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 20, 2007, lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Sun, Jun 17, 2007 at 12:52:38AM -0300, Alexandre Oliva wrote:
>> Why should restrictions through patents be unacceptable, but
>> restrictions through hardware and software be acceptable.

>> Both are means to disrespect users' freedoms.

> A patent prevents you from using the software in any way at all,
> while a hardware restriction prevents you from using the software on
> that particular hardware, but not on lots of other hardware.  Very
> big difference.

So, one disrespects a lot, the other disrespects a little.  Is that
relevant, when the requirement is "no further restrictions"?

>> It is the duty of the FSF to defend these freedoms.  It's its public
>> mission.  That's a publicly stated goal of the GPL, for anyone who
>> cares to understand it, or miss it completely and then complain about
>> changes in spirit.

> I wouldn't call it a duty.  It is the chosen mission perhaps, but nobody
> is making them do it.

Everyone who donates to it does so understanding what the mission is.
Detracting from that mission would be failing the public commitment.

Sure, it may have been self-imposed in the beginning, but maybe not
even then.  At least in Brazil, foundations are started by an initial
donor, who determines its mission, and it has a legal obligation to
pursue that mission, and IIRC it cannot be changed except by a court
order, and even than within certain limits.

> So what would happen if some company was to make software for a tivo and
> released their binaries signed with some specific key, and they released
> information on how to check this was signed with their key, and then
> some other companies went and made tivo hardware and decided that they
> would only allow code signed by the first companies key to run on it,

I was pretty sure this had been covered in the section about technical
barriers to modification in the third draft's rationale, but I can't
find it right now.  http://gplv3.fsf.org/gpl3-dd3-rationale.pdf

Anyhow, the argument I read went like: if there's an agreement between
the parties to do this, then the copyright holder can probably enforce
the license regardless of the software and hardware distributor being
different parties, since the software is being distributed with
information whose purpose is to enable the hardware to deny the user
the freedom to run modified versions of the software.

However, if there's no such agreement, if the copyright holder has no
copyright claims over the hardware or works shipped in it, there's
nothing the copyright holder can do about it, and that's probably how
it should be, since a copyright license (!= contract) can't possibly
prohibit people from creating hardware limited in function, it can
only tell people that, in order for them to have permission to modify
or distribute the covered work, they must abide by certain conditions.
And if they don't want to abide by the conditions, and they don't
manage to obtain a license from the copyright holders that doesn't
impose conditions they can't accept, they just can't modify or
distribute the work.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
