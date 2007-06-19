Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXFSGYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXFSGYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXFSGYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:24:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbXFSGYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:24:24 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Daniel Hazelton <dhazelton@enter.net>, Bron Gondwana <brong@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706161817.36657.dhazelton@enter.net>
	<orodjfmjsr.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706162306.14516.dhazelton@enter.net>
	<orwsy3l0jv.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617051451.GD21478@ftp.linux.org.uk>
	<orps3vjf93.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070618221511.GI21478@ftp.linux.org.uk>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 03:23:39 -0300
In-Reply-To: <20070618221511.GI21478@ftp.linux.org.uk> (Al Viro's message of "Mon\, 18 Jun 2007 23\:15\:12 +0100")
Message-ID: <orps3s4g44.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Al Viro <viro@ftp.linux.org.uk> wrote:

> I.e. the phrase about similar spirit should be replaced with
> something far more explicit and very, very hard to miss.

This is a very good idea.  Would you please file it at
http://gplv3.fsf.org/comments?

> I don't think you need more proof that people *do* interpret it in
> very different ways, with quite unpleasant results.
 
Agreed.

>> Is it correct to say that you share Linus' opinion, that the only
>> problem with the GPLv3 is the anti-tivoization provision?

> No.

Thanks for your detailed analysis.  I wish I knew what to do with
it.  (I decline impolite suggestions, thanks ;-)

Would you like me to put you in touch with Richard Fontana, one of the
lawyers involved in GPLv3, that's regarded as a legalese compiler, to
discuss your issues about wording with him?  Or would you rather file
them (with a bit more detail) at gplv3.fsf.org/comments?

Aside from wording issues, which appear to dominate your comments, is
it fair to characterize that your objections to GPLv3 are
anti-tivoization provisions (strong) and Affero compatibility (weak?)?


I'm setting wording issues aside because these are easier to fix once
the problem is understood, rather than ideological differences, that
would probably be pointless to attempt to fix.

> 	7	-	if I want to give additional permissions, I don't
> 			want them stripped, for fsck sake!  There is a
> 			bog-standard mechanism for _that_ (dual-licensing),
> 			thank you very much.

additional permissions are indeed a form of dual-licensing, but one
that doesn't require one to create a copy of the GPL and add the
additional permissions to that copy.  Yes, it could be accomplished
with dual-licensing terms such as "you can follow the terms of the
GPL, with the following additional permissions".

I don't quite see the point of criticizing this.  This is more
informative than anything else.

The meat here is really in the few additional restrictions, and the
provisions to combat the practice of adding restrictions on top of the
GPL and claiming the software is available under the GPL, which has
made for a lot of confusion over time.


Thanks a lot for your feedback.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
