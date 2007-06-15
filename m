Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbXFOVWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbXFOVWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbXFOVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:21:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXFOVVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:21:52 -0400
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706141014.21574.rgetz@blackfin.uclinux.org>
	<or1wgefmyn.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706151425.41975.rgetz@blackfin.uclinux.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 18:21:37 -0300
In-Reply-To: <200706151425.41975.rgetz@blackfin.uclinux.org> (Robin Getz's message of "Fri\, 15 Jun 2007 14\:25\:41 -0400")
Message-ID: <orzm30x6am.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Thu 14 Jun 2007 13:46, Alexandre Oliva pondered:
>> On Jun 14, 2007, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
>> > As a person pretty familiar with the hardware in these types of
>> > devices - this just isn't practical.
>> 
>> Well, then, ok: do all that loader and hardware signature-checking
>> dancing, sign the image, store it in the machine, and throw the
>> signing key away.  This should be good for the highly-regulated areas
>> you're talking about.  And then, since you can no longer modify the
>> program, you don't have to let the user do that any more.  Problem
>> solved.

> I don't think so - the GPL3 doesn't state that you must convey the same rights 
> to end users that you have,

Right, this is only in the preamble.

> it says you must provide installation information, including your
> keys, or you can not ship the product.

Unless you throw the keys away:

  this requirement does not apply if neither you nor any third party
  retains the ability to install modified object code on the User
  Product (for example, the work has been installed in ROM).

> I need to think a bit more of Rob's opinion of ROM's are illegal

See above ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
