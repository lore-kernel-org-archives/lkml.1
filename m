Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbXFOVJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbXFOVJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXFOVJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:09:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbXFOVJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:09:29 -0400
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Bernd Paysan" <bernd.paysan@gmx.de>,
       "Paulo Marques" <pmarques@grupopie.com>,
       "Al Viro" <viro@ftp.linux.org.uk>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706151014.45383.bernd.paysan@gmx.de>
	<46727CCF.9030905@grupopie.com>
	<200706151403.57178.bernd.paysan@gmx.de>
	<d120d5000706150552i4e1d7095p475be21d05d93e58@mail.gmail.com>
	<or4pl92hv5.fsf@oliva.athome.lsd.ic.unicamp.br>
	<d120d5000706151146u6f69667eodd2ff3f5e857a917@mail.gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 18:08:53 -0300
In-Reply-To: <d120d5000706151146u6f69667eodd2ff3f5e857a917@mail.gmail.com> (Dmitry Torokhov's message of "Fri\, 15 Jun 2007 14\:46\:35 -0400")
Message-ID: <or8xalx6vu.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> On 6/15/07, Alexandre Oliva <aoliva@redhat.com> wrote:
>> On Jun 15, 2007, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
>> 
>> > On 6/15/07, Bernd Paysan <bernd.paysan@gmx.de> wrote:
>> >> On Friday 15 June 2007 13:49, Paulo Marques wrote:
>> >>
>> >> > No, it is not "any version". It is the license specified in COPYING and
>> >> > nothing else.
>> >>
>> >> COPYING says in section 9 that there may be other versions, and if you as
>> >> author don't specify the version, it's "any version".
>> 
>> > Please read this sentence over and over until it sinks:
>> 
>> I believe he was talking about the sentence just after the one you
>> quoted:
>> 
>> If the Program does not specify a version number of this License,
>> you may choose any version ever published by the Free Software
>> Foundation.

> My response to this is that by including an entire copy of specific
> version of GPL in the release the version number was specified.

It's not that simple.  Including a copy of the license is a license
requirement for any redistributor, yes.

But if you, a sole copyright holder, were to distribute your program,
without any copy of the GPL, claiming "it's under the GPL", you're not
a violator.

Then, any redistributor adds a copy of any version of the GPL (because
you didn't specify a version number).  At this point, is the program
licensed by *you* only under this specific license?

Now, if you picked one of the various versions of the license, to make
things easier for redistributors, does it mean you're choosing that
particular version of the license, even though the license itself
says otherwise?

> You can't say that inclusion of copy of GPL is enough to specify
> class of licenses (all GPL) but not specific version.

I can't say either of these, indeed.  Or rather, I can, but I wouldn't
know whether I was right ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
