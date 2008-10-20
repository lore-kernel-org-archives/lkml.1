Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbYJTDtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbYJTDtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYJTDtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:49:45 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:51349 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751516AbYJTDto convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:49:44 -0400
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com>
	<20081016124943.GE23630@cs181140183.pp.htv.fi>
	<20081016151748.GA31075@kroah.com>
	<20081016153053.GJ5834@nostromo.devel.redhat.com>
	<20081016154726.GA6331@kroah.com>
	<20081016171626.GB22554@cs181140183.pp.htv.fi>
	<20081017040239.GB28188@kroah.com>
	<20081017103138.1ca68d17@lxorguk.ukuu.org.uk>
	<48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com>
	<48F98DE2.8030205@kernel.org>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Organization: Free thinker, not speaking for University of Campinas
Date: Mon, 20 Oct 2008 01:48:35 -0200
In-Reply-To: <48F98DE2.8030205@kernel.org> (H. Peter Anvin's message of "Sat\, 18 Oct 2008 00\:18\:58 -0700")
Message-ID: <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 18, 2008, "H. Peter Anvin" <hpa@kernel.org> wrote:

> Greg KH wrote:
>> What is the "problem" of predicting future releases?  What relies on the
>> actual number being "correct" some random time in the future?

> We already have the 2.6.28-rc series; and we are already talking about
> 2.6.29 features.

Just do like car manufacturers.  When it's 2008, you can already shop
around their 2009 models.  Linux could do the same.  We could right
now decide that 2.6.29 is going to be 2009.1 (or 9.1, or 2.9.1,
whatever), and then, even if it's still 2008 when it goes out, so
what?

(The 2.6.28 cycle has already started, so it's probably easier to just
leave it alone)

> We *really* don't want 2008.3-rc4 to be followed by 2009.1-rc5.
> That is the kind of stuff that make script makers want to strangle
> developers alive with their own intestines.

+1

Not that I care one way or the other.  It's just that I don't see how
your response bears any relationship with the point Greg made.  It's
just a distraction.  We're talking about how to label releases, not
about guessing the release date of a kernel months ahead.  One you
label it, it stays that way.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
