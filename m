Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbXFUD6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbXFUD6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXFUD6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:58:01 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:53616
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbXFUD6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:58:01 -0400
To: david@lang.hm
Cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKGEDMEMAC.davids@webmaster.com>
	<87ejk6qbco.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201959110.31603@asgard.lang.hm>
	<87645iq9pc.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706202026120.31603@asgard.lang.hm>
From: Michael Poole <mdpoole@troilus.org>
Date: Wed, 20 Jun 2007 23:58:00 -0400
In-Reply-To: <Pine.LNX.4.64.0706202026120.31603@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 20\:41\:49 -0700 \(PDT\)")
Message-ID: <871wg6q7qv.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

> On Wed, 20 Jun 2007, Michael Poole wrote:
>
>> david@lang.hm writes:
>>
>>> if the GPL can excercise control over compilations, then if Oracle
>>> were to ship a Oracle Linux live CD that contained the Oracle Database
>>> in the filesystem image, ready to run. then the GPL would be able to
>>> control the Oracle Database code.
>>
>> By copyright law, it could.  By its language, it does not.
>
> many people (including many lawyers will disagree that it could by
> copyright law

On what grounds would Oracle have a license to ship that part of
Linux?  Unless you are the sole copyright owner, you have no right to
copy a given piece of software _at all_ without a license.  The GPL is
a remarkably giving license in terms of how little it requires.

(This potentially wide scope is one of the major reasons that the GPL
mentions "mere aggregation" and that the Debian Free Software
Guidelines' include guideline #9.)

>>> if the GPL can't do this then it can't control the checksum either.
>>>
>>> again, it's not just the kernel that's part of the checksum on a tivo,
>>> the checksum is over the kernel + initial filesystem, much of which
>>> contains code not covered by the gPL)
>>
>> Again, did you miss where I pointed out that this makes it *worse* for
>> Tivo, because they are tying together -- and making inseparable -- a
>> combination that would otherwise be "mere aggregation"?
>
> and it makes most distro CD's illegal since they contain code under
> different incompatible licenses and they make a checksum across the
> entire CD image.

When distributions generate checksums (as opposed to signatures) over
images, they do provide all of the inputs.  When most distributions
provide signatures, the signatures do not function as statements or
instructions to computers -- they function as statements to users.
Tivo's digital signatures differ in both of these respects.

Michael Poole
