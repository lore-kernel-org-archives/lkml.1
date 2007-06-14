Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbXFNTaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbXFNTaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbXFNT3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:29:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710AbXFNT3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:29:43 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<alpine.LFD.0.98.0706131456230.14121@woody.linux-foundation.org>
	<orejkfla3l.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706131946.15714.dhazelton@enter.net>
	<20070614004419.GL3588@stusta.de>
	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706140817520.14121@woody.linux-foundation.org>
	<orsl8ue7ou.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141106540.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 16:28:22 -0300
In-Reply-To: <alpine.LFD.0.98.0706141106540.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 11\:14\:11 -0700 \(PDT\)")
Message-ID: <orfy4ucp49.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Jun 2007, Alexandre Oliva wrote:
>> 
>> > In other words, Red Hat distributes copies (and yes, you *get* that copy), 
>> > and you cannot modify that copy that you got.
>> 
>> And Red Hat can't either.  I thought that was quite obvious.

> The GPLv2 talks about specific rights, like the ability to make changes 
> and distribute things, and says that you have to give downstream all those 
> same rights.

The spirit gives the intuition of "passing on all the rights".  The
legal terms have to be more careful about that, to avoid the very
situation you're debating, so they state "you can't impose further
restrictions on the exercise of the rights".

Do you understand the difference?

> For example, for any code that I have full copyright over, I have rights 
> that you DO NOT HAVE!

No dispute about that, and this is irrelevant to this point.  I've
already responded and clarified this point 2 or 3 times in this
thread.  Do you need me to find a URL for you?  It was in respose to
Dmitri Torokhov.

> So if you want to argue that I should re-license, you should argue that 
> the GPLv3 is better. And quite frankly, you haven't.

In fact, I haven't even tried.  So far, I've merely been trying to
show that it still follows the same spirit, dispelling the muth that
it doesn't, and trying to understand why you think GPLv2 is so much
better, which I think is related with tit-for-tat and retribution in
kind.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
