Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbXFOC1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbXFOC1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXFOC1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:27:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbXFOC1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:27:15 -0400
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
	<20070614234507.GA3860@nostromo.devel.redhat.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 23:25:57 -0300
In-Reply-To: <20070614234507.GA3860@nostromo.devel.redhat.com> (Bill Nottingham's message of "Thu\, 14 Jun 2007 19\:45\:08 -0400")
Message-ID: <or1wge6jii.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Bill Nottingham <notting@redhat.com> wrote:

> Alexandre Oliva (aoliva@redhat.com) said: 
>> And since the specific implementation involves creating a derived work
>> of the GPLed kernel (the signature, or the signed image, or what have
>> you)

> Wait, a signed filesystem image that happens to contain GPL code
> is now a derived work? Under what sort of interpretation does *that*
> occur?

Is the signature not derived from the bits in the GPLed component, as
much as it is derived from the key?

Isn't the signature is a functional portion of the image, i.e., if I
take it out from the system, it won't work any more?

> (This pretty much throws the 'aggregation' premise in GPLv2 completely
> out.)

Not really.  It could take some explicit distinguishing between
functional and non-functional signatures, but that's about it.

GPLv3 chose a different path to make this clarification.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
