Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbXFSGLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbXFSGLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXFSGLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:11:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbXFSGLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:11:22 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: mea culpa on the meaning of Tivoization
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706181808.18007.dhazelton@enter.net>
	<orabuw8xdb.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706182325.22067.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 03:10:02 -0300
In-Reply-To: <200706182325.22067.dhazelton@enter.net> (Daniel Hazelton's message of "Mon\, 18 Jun 2007 23\:25\:21 -0400")
Message-ID: <ortzt44gqt.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> I haven't looked at it, in depth, today but one of the problems I
> saw was the apparent loopholes in the text. No specifics, but I
> remember thinking "a lawyer would have a field day with this -
> dozens of ways they could sidestep these issues"

*Pretty* *please* file comments about the apparent loopholes at
gplv3.fsf.org/comments

> What I was getting at, here, is that the GPLv3 isn't backwards
> compatible with GPLv2,

It couldn't possibly be.  The whole point of upgrading the GPL is such
that it complies better with its spirit of defending the freedoms, so
as to keep free software free.  This can only be accomplished with
additional restrictions that stop practices that deny users'
freedoms.

Relaxing the provisions, a necessary condition for compatibility,
wouldn't make for better defenses.

> because you aren't allowed to remove rights from the GPLv3. Remember, 
> there are rights encoded in the GPLv3 that don't appear in v2.

I'm not sure what you mean by "rights" in the two sentences above.
You know you can grant additional permissions, so I assume that's not
what you mean, even more so because you *can* indeed take them out.
Is it "conditions", "restrictions" or some such, that in turn
translate into freedoms for downstream users, or is it about the
granted rights per se?

> In fact, if you want to use GPLv3 code in a GPLv2 project you have
> to use GPLv3. For some projects, like the Linux Kernel, the upgrade
> is impossible to accomplish.

Impossible is a bit too strong.  I understand it would take a huge
amount of work though, so I sympathize with "it wouldn't be worth it",
even if, in my scale of moral values, I'd disagree.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
