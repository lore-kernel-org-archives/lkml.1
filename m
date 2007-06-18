Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbXFRVNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbXFRVNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762198AbXFRVNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:13:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760606AbXFRVNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:13:05 -0400
To: "David Schwartz" <davids@webmaster.com>
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKCECMELAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 18:12:57 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCECMELAC.davids@webmaster.com> (David Schwartz's message of "Mon\, 18 Jun 2007 13\:13\:51 -0700")
Message-ID: <ory7ih9dba.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> > Sure, and you use the hardware to stop me from modifying the
>> > Linux on your
>> > laptop.

>> Do I?  How so?

> Any number of ways. For example, you probably don't connect the serial ports
> to a device I have access to.

But you're not the user of the software on my laptop.  I am.

> I'm sorry, who is "the user"? Who exactly is supposed to be able to install
> and run modified versions? How does the GPLv3 specify who is supposed to be
> authorized to do this?

Aah, good question.  Here's what the draft says about this:

  Mere interaction with a user through a computer network, with no
  transfer of a copy, is not conveying.

The requirements as to "installation information" apply to conveying
the program along with a user product.


> How exactly does the GPLv3 specify who should and should not be able to
> change the software on a particular physical machine?

IANAL, but my understanding is that (paraphrasing), when you convey
the software along with a user product, you must permit the recipient
of the software to install and run modified versions of the software
in the user product as well.

>> A condition that is
>> arguably already encoded in the "no further restrictions to the rights
>> granted" by the license" and to the requirement for complete
>> corresponding source code to accompany the binary.

> Except that the "right" to upload the software on some particular piece of
> hardware was *never* a right granted by the GPL, nor could it be.

It is a restriction on adapting the software installed in the machine,
and a restriction on running the software on that machine.  You can
argue these are not granted by GPLv2.  You may be right.  But per the
spirit of the GPL, they should be protected, and so GPLv3 fixes the
legal conditions such that they are.

> That *HAS* to be a right granted by whatever authority controls the
> use of that hardware.

What if the authority that controls the use of the hardware is
forbidding from restricting this possibility by law?  By contractual
provisions?  By a patent license?  By a copyright license?

> It's totally obvious that who gets to install what software on a
> given piece of hardware is determined by the person who creates/owns
> that hardware and they have to authorize anyone else to change it.

If who creates and who owns are different people, who gets to decide it?

> It is not. The GPL was never about who was allowed to modify the
> software on particular pieces of hardware. It was about the lack of
> *legal* obstacles to your doing so.

GPL has never been concerned *only* about *legal* obstacles.  In fact,
the only obstacle GPLv1 addressed by name was not a legal, but a
technical obstacle: denying access to source code.  Your distinction
is flawed.

>> Both are means to disrespect users' freedoms.

> The freedom to control what software runs on someone else's hardware?!

Freedom to control the software you use on the hardware you use it.

Someone else's hardware is just a distraction.  You're not a user of
software on someone else's hardware.  You have no rights over that.

> And I think they change it utterly by treating one piece of hardware
> different from others for GPL purposes.

No, it's tivoization that does this.

Tivoizers say "hey, you can still modify and run the software, just
not on *this* hardware".

GPLv3 says you must make this artificial distinction.  You must not
place barriers on the freedoms of the user WRT to the GPLv3 software
they use on the hardware you sold/rented/leased/lent/gave them along
with the GPLv3 software you meant them to use.

You can't waive your hands to escape your obligations saying "you can
run it elsewhere", in just the same way you can't escape your GPLv2
obligations to provide source code saying "you can download it
elsewhere"

> GPL was always about equal freedom to use the software on *ALL*
> hardware, not special rights to use it on one piece of hardware.

Exactly.  But tivoizers are making these distinctions, trying to frame
their hardware as somehow special, even though the users that receive
the hardware with the software become users of the software on that
very hardware, and that's why they must be able to enjoy the freedoms
on that very hardware.  Not being able to enjoy them elsewhere could
defensibly be not the vendor's fault.  Not being able to enjoy them on
that hardware is obviously the result of choices made by the vendor,
since the vendor *could* put the software there and get it to run.
Why couldn't the user?

> More importantly, the change in scope to claim rights over things
> that are not derivative works and do not include any GPL'd code is
> so massive that it's a change in spirit, IMO.

Show how patents whose licenses are implicitly granted under GPLv2 are
derivative works and your argument might begin to make sense.


Oh, and user products that GPLv3 talks about *do* include GPLv3 code,
otherwise the license is irrelevant for them, since GPLv3 code is not
being conveyed.  I guess you meant something else when you wrote "do
not include any GPL'ed code".

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
