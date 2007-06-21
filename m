Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbXFUXiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbXFUXiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbXFUXh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:37:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXFUXh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:37:56 -0400
To: davids@webmaster.com
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKOEJBEMAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 20:37:46 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEJBEMAC.davids@webmaster.com> (David Schwartz's message of "Thu\, 21 Jun 2007 14\:13\:36 -0700")
Message-ID: <orr6o4j2ut.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> Are you seriously suggesting that the Linux kernel source contain code with
> various different licenses

It already does.  All the way from permissive Free Software licenses
to GPLv2-incompatible non-Free Software licenses.

> Over time, the code will get so combined and interwoven that the
> intersection of all permitted licenses would soon apply to
> effectively the entire kernel.

If you don't keep things clearly separate, yes.

I was honestly thinking more along the lines of ZFS as a separate
driver than about your bringing GPLv3 code into the core of the
kernel.

But then, it would be your call either way.

This option of mutual cooperation wouldn't work for either party if
you're not willing to cooperate, and that's what I believe makes it
fair.

Now, if you guys can't recognize a goodwill gesture when you see one,
and prefer to live in the paranoid beliefs that "those evil FSFers are
trying to force me into a situation in which they'll then be able to
steal my code", that's really up to you.  Don't try to shift the blame
of your decisions onto the FSF.

One thing is missing the spirit of the GPL and using it to serve a
different purpose, without realizing it doesn't provide you with
exactly what you want (tivoization, for example); another completely
different is to try to put it as FSF's fault that clarifications and
amendments are desirable to ensure the ability for authors to enforce
the intent of the GPL.

> Unless, that is, GPLv3 makes itself compatible with GPlv2.

Hey, but that was precisely what I was suggesting!  Except that it
wasn't with GPLv2 alone, because this doesn't work.  Each copyleft
license insists that it be *the* license.  So, in order to be able to
combine two copyleft licenses, you need mutual compatibility
provisions in both.  Which is what I was proposing.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
