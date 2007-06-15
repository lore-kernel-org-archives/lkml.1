Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbXFOS2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbXFOS2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXFOS2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:28:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbXFOS2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:28:03 -0400
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
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 15:27:26 -0300
In-Reply-To: <d120d5000706150552i4e1d7095p475be21d05d93e58@mail.gmail.com> (Dmitry Torokhov's message of "Fri\, 15 Jun 2007 08\:52\:05 -0400")
Message-ID: <or4pl92hv5.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> On 6/15/07, Bernd Paysan <bernd.paysan@gmx.de> wrote:
>> On Friday 15 June 2007 13:49, Paulo Marques wrote:
>> 
>> > No, it is not "any version". It is the license specified in COPYING and
>> > nothing else.
>> 
>> COPYING says in section 9 that there may be other versions, and if you as
>> author don't specify the version, it's "any version".

> Please read this sentence over and over until it sinks:

I believe he was talking about the sentence just after the one you
quoted:

  If the Program does not specify a version number of this License,
  you may choose any version ever published by the Free Software
  Foundation.

Linux files don't all specify version 2, but Linus, Al Viro and other
authors very clearly mean their contributions to be version 2 only,
while others very clearly mean their contributions to be v2+.

The moment anyone makes copyrightable changes to any such files, and
offers them under GPLv2 only (if that's at all possible; I used to
believe so, but I've read interesting, even if surprising, arguments
indicating it might not be), the result of the modification is GPLv2
only.

So there's no doubt that the whole of the kernel is meant to be under
GPLv2 only, even if some individual authors may choose to make their
contributions available under other licenses, and be willing to make
such offers when they are legally entitled to do so.


I don't quite understand what this fuss is all about.  Even if a
majority of the Linux authors had chosen GPLv2+, or GPLvany, if any
single author makes a contribution under GPLv2 only, and that
contribution is integrated, that's a veto for distributing the whole
under any other license.  This single contributor could dictate his
choice upon others, as long as his contribution was present.

IANAL, but I believe that's how it works.  And this means Linux is
under GPLv2, no matter how much of the code in it is available under
any other versions of the GPL, or even different (but compatible)
licenses.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
