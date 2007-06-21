Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbXFUX6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbXFUX6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXFUX6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:58:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbXFUX6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:58:21 -0400
To: Andrew McKay <amckay@iders.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615012623.GA25189@elte.hu>
	<20070615101007.0cbfd078@the-village.bc.nu>
	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4673CA7C.5040207@t-online.de>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4679557C.5080907@iders.ca>
	<20070620175627.319a6c55@the-village.bc.nu>
	<46797C52.4020907@iders.ca>
	<20070621122221.27fd7648@the-village.bc. nu>
	<467A99D6.6000605@iders.ca>
	<ory7idjdhn.fsf@oliva.athome.lsd.ic.unicamp.br>
	<467ADC8A.5080401@iders.ca>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 20:56:58 -0300
In-Reply-To: <467ADC8A.5080401@iders.ca> (Andrew McKay's message of "Thu\, 21 Jun 2007 15\:16\:10 -0500")
Message-ID: <ormyysj1yt.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, Andrew McKay <amckay@iders.ca> wrote:

> Alexandre Oliva wrote:
>> On Jun 21, 2007, Andrew McKay <amckay@iders.ca> wrote:
>> 
>>> A balance of freedom to the licensee and the licenser.  It's my
>>> opinion that GPLv3 potentially shifts the balance too far to the
>>> licensee.
>> 
>> It's more of a balance of freedom between licensee and licensee,
>> actually.  It's a lot about making sure no one can acquire a
>> privileged position, such that every licensee plays under the same
>> rules.  (The copyright holder is not *acquiring* a privileged
>> position, copyright law had already granted him/her that position.)

> I do see what you're saying here.  But it does take the away the
> ability of a licensee to protect themselves from another malicious
> licensee.

Sorry, I don't follow what the "it" refers to in your sentence.

> If the ultimate goal of the Free Software community is to get source
> code out to the public, I think that was captured in GPLv2.

That's a correct logical inference, but since the premise is false,
the conclusion is garbage.

GPLv2 goes far beyond getting source code out to the public.  It
contains the "no further restrictions" language, which is very
powerful.  It is pretty obvious that when Linus adopted GPLv2 he
didn't realize it reached that point.  That when Tivo invented
Tivoization, he decided he wanted to permit this, and thus grants an
implicit additional permission for anyone to do it with his code,
doesn't mean other participants in the Linux community feel the same
way, or read the GPLv2 the same way, and could be somehow stopped from
enforcing the license the way they meant it.

Ultimately, the current situation is that we have two
mutually-incompatible license intents being used in Linux, and no
matter how much those who want to grant the permission say so, this
doesn't trample other contributor's rights to enforce the license they
chose for their code.  Especially those who started contributing long
before the decision that "what TiVo does is good" was announced.

Now, since these two license intents are expressed by the same
license, and what the license demands is that derived works must be
under the same license, they are compatible, but since the intents are
distinct, what prevails is, as in any case of combination of different
licensing provisions, is the most restrictive provision.

So Linux does not permit tivoization today.  Linus does, Linux
doesn't.

All this fuss about the anti-tivoization provisions in GPLv3 is just a
consequence of reading the GPLv2 without fully understanding its
intended consequences, not having foresight to clarify the intent to
constrain the "no further restrictions" provisions to match the
alternate interpretation, and opposing the removal of the ambiguity
because it doesn't match the choice that *some* of the developers
would like it to go.

Who's the ambiguity good for?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
