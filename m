Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbXFUEUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbXFUEUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXFUEUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:20:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbXFUEUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:20:02 -0400
To: david@lang.hm
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       David Schwartz <davids@webmaster.com>,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKKEIFEKAC.davids@webmaster.com>
	<orodjfkzjt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070620140101.GU10008@csclub.uwaterloo.ca>
	<or1wg6uz53.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706201407560.30395@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 01:19:45 -0300
In-Reply-To: <Pine.LNX.4.64.0706201407560.30395@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 14\:09\:46 -0700 \(PDT\)")
Message-ID: <orlkeerlb2.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 20, 2007, david@lang.hm wrote:

> On Wed, 20 Jun 2007, Alexandre Oliva wrote:
>> On Jun 20, 2007, lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:
>>>> It is the duty of the FSF to defend these freedoms.  It's its public
>>>> mission.  That's a publicly stated goal of the GPL, for anyone who
>>>> cares to understand it, or miss it completely and then complain about
>>>> changes in spirit.
>> 
>>> I wouldn't call it a duty.  It is the chosen mission perhaps, but nobody
>>> is making them do it.
>> 
>> Everyone who donates to it does so understanding what the mission is.
>> Detracting from that mission would be failing the public commitment.

> true, but selecting the GPL as the license for your project is not
> donating to the FSF.

Oh, that's what you meant.  Indeed, absolutely not.

The GPL is "just" a set of permissions you, as an author, grant to
anyone who comes across your program.

Whether you share FSF's goals or not, you can do that.

If you share FSF's goals of not only respecting users' freedoms, but
also defending them as much as deemed legally possible under copyright
law, you can also offer your code under any later version of the GPL,
such that it remains usable by the community who cares about this.

In theory, this shouldn't be a problem for anyone who chose the GPLv2,
since all of the permissions granted by GPLv3 are granted by GPLv2,
and this is how it should be.  The difference is that GPLv3 plugs some
holes that were found in GPLv2, in a similar way that GPLv2 plugged
holes found in GPLv1, and GPL "plugs holes" in LGPL, which "plugs
holes" in other even more permissive licenses.

Each GPL revision is expected to plug holes ("address new problems",
as in the legal terms of GPLv2) that might enable licensees to deny
other licensees the rights you meant to grant them.

This will necessarily make each revision incompatible with the
previous, for being stricter, thus imposing further restrictions, even
if only by removing exploitable ambiguities.  This should have been
clear since GPLv1, anyone who understands the goals of the GPL and
with enough foresight to understand the recommendation of permitting
relicensing under newer versions should be able to see this.

So, since new restrictions are always on licensees' ways to deny other
licensees the enjoyment of the permissions you meant to grant them, if
you mean to permit people to use your work in the ways permitted by
GPLv2, not permitting them to be used in GPLv3 software amounts to
pure selfishness: "if I won't get to use your code, you don't get to
use mine."  Tit-for-tat, for sure, but certainly not in the spirit of
sharing clearly established early in the preamble of every version of
the GPL.

Permitting such relicensing wouldn't deny anyone any freedom, and it
wouldn't create any obligations whatsoever for the licensor.  Whoever
wanted to use the work under the more liberal terms of the earlier
version of the GPL under which the work was licensed still could: this
license can't be unilaterally revoked, not by you, not by anyone else.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
