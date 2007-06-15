Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbXFOO5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbXFOO5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXFOO47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:56:59 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:54183
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144AbXFOO46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:56:58 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706142246.57583.dhazelton@enter.net>
	<878xal2a0q.fsf@graviton.dyn.troilus.org>
	<200706150127.18069.dhazelton@enter.net>
	<87sl8tzaj1.fsf@graviton.dyn.troilus.org>
	<20070615124039.GB21120@elte.hu>
	<87fy4tz8dc.fsf@graviton.dyn.troilus.org>
	<20070615143003.GA8775@elte.hu>
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 15 Jun 2007 10:56:57 -0400
In-Reply-To: <20070615143003.GA8775@elte.hu> (Ingo Molnar's message of "Fri\, 15 Jun 2007 16\:30\:03 +0200")
Message-ID: <87zm31xo3q.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Michael Poole <mdpoole@troilus.org> wrote:
>
>> >> I do not suggest that copyright subsists in the signature or in the 
>> >> signing key.  Whether it does is irrelevant to the signing key 
>> >> being part of the source code (when the signature is needed for the 
>> >> binary to work properly).
>> >
>> > it is very much relevant. By admitting that the key is not part of 
>> > the "work", you have lost all moral basis to claim control over it.
>> 
>> I have not admitted any such thing.  I have said the key and signature 
>> do not have separate copyright protection.  Variables named "i" in a 
>> file are not protected by copyright, but they are very much part of 
>> the source code in that file.
>
> the problem with your argument is that the definition of what 
> constitutes "work" is up to copyright law, _not_ the license writer. 

Linux is unquestionably a work protected under copyright law.  When I
compile Linux, copyright law still protects the executable form.  This
is not a problem.

> I.e. you cannot just cleverly define "source code" to include something 
> unrelated and then pretend that it's all in one work. And that's exactly 
> what the GPLv3 does: it creatively defines the hardware's key into the 
> 'source code' of the software and then asks for that to be provided 
> _not_ because somehow the key derives from the software (it clearly does 
> not), but as a "compensation" for the right to redistribute! I.e. it's 
> trying to extend its scope to some item that is not part of the 
> software. See?

No.  The GPL does not care about the hardware's key, as I pointed out
in the part of my email that you cut out.  The GPL cares about the key
used to generate an integral part of the executable form of the GPLed
work.  The executable does not function properly if it lacks that
part.  This is exactly the same way in which the GPL cares about the
programming instructions in other parts of the source code: if you
remove them, the resulting work does something quite different.  See?

Michael Poole
