Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbXFODU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbXFODU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 23:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXFODUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 23:20:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbXFODUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 23:20:48 -0400
To: Florin Malita <fmalita@gmail.com>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706140305.50095.dhazelton@enter.net>
	<orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>
	<46717C58.8050501@gmail.com>
	<ord4zye6iv.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4671A528.5040300@gmail.com>
	<or1wge9pwr.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4671F127.40000@gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 00:19:24 -0300
In-Reply-To: <4671F127.40000@gmail.com> (Florin Malita's message of "Thu\, 14 Jun 2007 21\:53\:43 -0400")
Message-ID: <or8xal6h1f.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Florin Malita <fmalita@gmail.com> wrote:

> On 06/14/2007 05:39 PM, Alexandre Oliva wrote:
>> Back when GPLv2 was written, the right to run was never considered an
>> issue.  It was taken for granted, because copyright didn't control
>> that in the US (it does in Brazil), and nobody had thought of
>> technical measures to stop people from running modified copies of
>> software.  At least nobody involved in GPLv2, AFAIK.

>> The landscape has changed, and GPLv3 is meant to defend this
>> freedom that was taken for granted.

> Then you agree that GPLv2 does not protect your freedom (taken for
> granted) to run a modified copy on any particular device, or am I
> misreading?

IANAL, but AFAICT it doesn't.  Still, encoded in the spirit (that
refers to free software, bringing in the free software definition), is
the notion of protecting users' freedoms, among them the freeom #0, to
run the software for any purpose.

That's why I believe it's in the spirit of the license to defend this
freedom.

And that's why lawyers in Brazil believe that, even though the GPL
does not affirm the right to run the software, it fits the bill,
because, under the light of the preamble, the free software
definition, and the US copyright law, it should be interpreted as an
intent to grant permission to run the software.

> Hence, Tivo is not really *modifying* the copies it distributes with
> the device - they're *installing* brand new copies instead. They
> also choose not to offer everybody the same privilege :-|

Got it.  That's bad.  :-(

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
