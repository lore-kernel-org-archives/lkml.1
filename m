Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbXFSCsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbXFSCsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763435AbXFSCsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:48:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760820AbXFSCsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:48:31 -0400
To: =?utf-8?Q?Hans-J=C3=BCrgen?= Koch <hjk@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>,
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
	<200706182144.06825.hjk@linutronix.de>
	<ortzt59d2r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706182331.19571.hjk@linutronix.de>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 23:46:30 -0300
In-Reply-To: <200706182331.19571.hjk@linutronix.de> (=?utf-8?Q?=22Hans-J?=
 =?utf-8?Q?=C3=BCrgen?= Koch"'s message of "Mon\, 18 Jun 2007 23\:31\:19
 +0200")
Message-ID: <orejk88xvd.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Hans-Jürgen Koch <hjk@linutronix.de> wrote:

> Am Montag 18 Juni 2007 23:18 schrieb Alexandre Oliva:
>> On Jun 18, 2007, Hans-Jürgen Koch <hjk@linutronix.de> wrote:
>> 
>> >> Vendor would be entitled to the benefit of the doubt as to the
>> >> motivations in this case, so it would likely be unenforceable anyway.
>> 
>> > Right. If GPL v3 comes out, there'll probably be a new task for
>> > hardware development engineers: How to find excuses for hardware that
>> > prevents software modifications and how to conceal the true intent.
>> 
>> Yup.  And then GPLv4 will have to plug whatever holes they find to
>> disrespect users' freedoms.  That's how I expect the game to be
>> played.

> If you were right and it turned out that way, the whole GPL would
> become so ridiculous that it won't have any of its intended effects.

How so?  The intended effects are to protect users' freedoms, by
requiring them to be respected.  If we keep on plugging holes as they
appear, it will keep close to achieving its intended effects.  It's
earlier versions of the license that will get more and more distant
from it.

> As far as the kernel is concerned, I expect the game's played by
> simply keeping GPLv2. And I like it that way.

Just think about it...  What if, today, some law passed, or some court
decision came up, that rendered a significant defense provision of
GPLv2 or GPLv3 ineffective?

GPLv4 could plug that, and anyone using GPLvN+ would be able to switch
to it immediately.  This wouldn't revoke previous licenses, of course,
but further developments could be made under the newer license, and at
least those could still be defended, and, as time elapsed, earlier
versions of the software would become less and less relevant, to the
point that the holes in their license also become less and less
relevant, until copyright finally expires and they enter the public
domain.


The distrust for the FSF led to this very short-sighted decision of
painting the Linux community into a corner from which it is very
unlikely to be able to ever leave, no matter how badly it turns out to
be needed.  Let's just hope it never is, or that some influx of
long-sighted comes in and introduces mechanisms for the license of
Linux to be patched, should this ever be needed.  I'm not even talking
about GPLv2+, there are many other ways to accomplish this, that I've
already mentioned in another posting in another recent huge thread.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
