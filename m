Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbXFSSez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbXFSSez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761003AbXFSSes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:34:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760973AbXFSSeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:34:46 -0400
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
	<200706182331.19571.hjk@linutronix.de>
	<orejk88xvd.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706191022.21869.hjk@linutronix.de>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 15:32:58 -0300
In-Reply-To: <200706191022.21869.hjk@linutronix.de> (=?utf-8?Q?=22Hans-J?=
 =?utf-8?Q?=C3=BCrgen?= Koch"'s message of "Tue\, 19 Jun 2007 10\:22\:21
 +0200")
Message-ID: <orbqfb3icl.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, Hans-Jürgen Koch <hjk@linutronix.de> wrote:

> Am Dienstag 19 Juni 2007 04:46 schrieb Alexandre Oliva:
>> The distrust for the FSF led to this very short-sighted decision of
>> painting the Linux community into a corner from which it is very
>> unlikely to be able to ever leave, no matter how badly it turns out to
>> be needed.  

> I'm neither in a corner nor do I feel the need for a different license.

Yes.  Some day you may.  And then what will you or anyone else be able
to do about it?

>> Let's just hope it never is, or that some influx of 
>> long-sighted comes in 

> Kernel programmers are short-sighted? What kind of arrogance is that?

It's just stating the obvious.  The upgrade path is a nightmare.

A long-sighted decision should have established *some* means for a
quick fix should it be needed.  It didn't have to be GPLv2+.  In fact,
per the stated goals and general feelings, it probably *shouldn't* be
GPLv2+.  But cutting any reasonable possibility of fixing a legal
problem in the license is short-sighted, yes.  It's putting too much
trust in the perfection of the license *and* the worldwide legal
systems *and* legislators.

>> and introduces mechanisms for the license of 
>> Linux to be patched, should this ever be needed.  

> You know pretty well that Linus clearly said he would change the license
> when _he_ thinks it's needed.

And what makes you think even *he* can change the license?

> The point is that _you_ want him to change the license to support
> _your_ political ideas.

I would like him to, yes.  But this is besides the point.  That I see
reasons for an upgrade, and that I'd like such an upgrade, doesn't
make any difference whatsoever about the plain fact that relicensing
Linux today, to any other license and for whatever reason it was,
would be a nightmare, and that this is a consequence of the
short-sighted decision of not establishing a relicensing procedure.

At this point, the situation is very much like a kernel installed in
ROM.  Who knows that nobody will ever find security bugs in it?  How
would you go about fixing them?

>> I'm not even talking 
>> about GPLv2+, there are many other ways to accomplish this, that I've
>> already mentioned in another posting in another recent huge thread.

> I partly read that "recent huge thread". Linus elaborated his point of 
> view in detail, and I very much share his opinion.

Huh?  It looks like you're talking about something unrelated with
license patching procedures.  I don't think Linus ever responded in
that thread to my suggestions of various means to establish a license
patching procedure.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
