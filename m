Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbXFPT2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbXFPT2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 15:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbXFPT2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 15:28:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbXFPT2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 15:28:20 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616103130.GD32405@brong.net>
	<orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706161431.58245.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sat, 16 Jun 2007 16:27:37 -0300
In-Reply-To: <200706161431.58245.dhazelton@enter.net> (Daniel Hazelton's message of "Sat\, 16 Jun 2007 14\:31\:58 -0400")
Message-ID: <ortzt7pumu.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> I don't see how TiVO has done this. They have placed no restrictions on 
> *modification* at all. What they have done is placed a restriction on 
> *REPLACEMENT* of the program.

Technicality.  In order for the software to remain free (which is what
the GPL is all about), the user must not be stopped from adapting the
software to suit his needs and running it for any purpose.  TiVo
places restrictions on it.  It's really this simple.

And then, TiVo doesn't really prohibit replacement.  You can replace
it as much as you like; just not as conveniently as TiVo can replace
it.  And then, if you do, it won't run, because it's not signed with a
key that they omit from the source code.  And they do this in order to
prevent the user from changing the behavior of the Free Software that
they use, while they keep this ability to themselves.

If these are not restrictions on the freedoms that the GPL is designed
to protect to ensure that Free Software remains Free for all its
users, I don't know what is.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
