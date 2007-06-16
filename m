Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXFPDZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXFPDZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 23:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbXFPDZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 23:25:17 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:34425 "EHLO
	asav17.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXFPDZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 23:25:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlE4ALb0ckZKhRO4UGdsb2JhbACBToVjh3sBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 23:25:13 -0400
User-Agent: KMail/1.9.3
Cc: Bernd Paysan <bernd.paysan@gmx.de>, Paulo Marques <pmarques@grupopie.com>,
       Al Viro <viro@ftp.linux.org.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <d120d5000706151146u6f69667eodd2ff3f5e857a917@mail.gmail.com> <or8xalx6vu.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or8xalx6vu.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152325.14244.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 17:08, Alexandre Oliva wrote:
> On Jun 15, 2007, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
> 
> > On 6/15/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> >> On Jun 15, 2007, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
> >> 
> >> > On 6/15/07, Bernd Paysan <bernd.paysan@gmx.de> wrote:
> >> >> On Friday 15 June 2007 13:49, Paulo Marques wrote:
> >> >>
> >> >> > No, it is not "any version". It is the license specified in COPYING and
> >> >> > nothing else.
> >> >>
> >> >> COPYING says in section 9 that there may be other versions, and if you as
> >> >> author don't specify the version, it's "any version".
> >> 
> >> > Please read this sentence over and over until it sinks:
> >> 
> >> I believe he was talking about the sentence just after the one you
> >> quoted:
> >> 
> >> If the Program does not specify a version number of this License,
> >> you may choose any version ever published by the Free Software
> >> Foundation.
> 
> > My response to this is that by including an entire copy of specific
> > version of GPL in the release the version number was specified.
> 
> It's not that simple.  Including a copy of the license is a license
> requirement for any redistributor, yes.
> 
> But if you, a sole copyright holder, were to distribute your program,
> without any copy of the GPL, claiming "it's under the GPL", you're not
> a violator.
>

Distributing a copy of GPL is not a requirement for me as a licensor
however I did chose to include a copy of a specific version of a
specific license and did not make any other statements that is the
license for the work.
 
> Then, any redistributor adds a copy of any version of the GPL (because
> you didn't specify a version number).  At this point, is the program
> licensed by *you* only under this specific license?
>

If they did not make any changes then they have to include the earliest
version of GPL that applies. If they did modifications and chose GPLv4
they will have to include GPL v4 (if such requirement is in GPLv4) because
what good any other license will do me?
 
> Now, if you picked one of the various versions of the license, to make
> things easier for redistributors, does it mean you're choosing that
> particular version of the license,

Yes, this is my opinion.

> even though the license itself 
> says otherwise?
>

License does not say otherwise. License says that if there is an
_additional_ stipulation my the licensor then some other license
(non existing yet license) may be used. They had to use this wording
because these licensed do not exist yet. If GPL would say:

"If the Program specifies a version number of this License which
applies to it and "or BSD license", you have the option of following
the terms and conditions either of that version or of BSD license"

would you still say that BSD is allowed by default by GPL? "GPL v2
and later versions" is not different from "GPL v2 or BSD" or
"GPLv2 or CDDL".  

> > You can't say that inclusion of copy of GPL is enough to specify
> > class of licenses (all GPL) but not specific version.
> 
> I can't say either of these, indeed.  Or rather, I can, but I wouldn't
> know whether I was right ;-)
> 

-- 
Dmitry
