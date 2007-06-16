Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbXFPFRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbXFPFRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 01:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXFPFRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 01:17:06 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:11583 "EHLO
	asav07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbXFPFRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 01:17:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlE4AOwOc0ZKhRO4UGdsb2JhbACBToVjh3sBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sat, 16 Jun 2007 01:17:01 -0400
User-Agent: KMail/1.9.3
Cc: Bernd Paysan <bernd.paysan@gmx.de>, Paulo Marques <pmarques@grupopie.com>,
       Al Viro <viro@ftp.linux.org.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <200706152325.14244.dtor@insightbb.com> <ory7iksgip.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ory7iksgip.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706160117.02459.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 23:51, Alexandre Oliva wrote:
> On Jun 16, 2007, Dmitry Torokhov <dtor@insightbb.com> wrote:
> 
> > On Friday 15 June 2007 17:08, Alexandre Oliva wrote:
> >> >> If the Program does not specify a version number of this License,
> >> >> you may choose any version ever published by the Free Software
> >> >> Foundation.
> 
> > Distributing a copy of GPL is not a requirement for me as a licensor
> > however I did chose to include a copy of a specific version of a
> > specific license and did not make any other statements that is the
> > license for the work.
>  
> And the copy you chose to include says the above.
> 
> Are you absolutely sure you could terminate the license of a
> distributor that refrains to pass on a patent license it obtained, if
> you included a copy of the GPLv2 without any other indication that
> you're choosing GPLv2 and no other version of the GPL, in spite of the
> above?
> 

You never sure about anything taht involves lawyers ;)

> Would it change anything if you had released the program back when
> GPLv3 wasn't under discussion, and GPLv1 was long forgotten, so most
> people (yourself included) only referred to it as GPL, or GNU GPL?
> 
> >> Then, any redistributor adds a copy of any version of the GPL (because
> >> you didn't specify a version number).  At this point, is the program
> >> licensed by *you* only under this specific license?
> 
> > If they did not make any changes then they have to include the earliest
> > version of GPL that applies.
> 
> Why?  Why does it have to be the earliest?

Earliest is wrong I suppose. What I meant is post permissive. Otherwise it
does not make any sense. And what about if there is a version of GPL that
does not require passing a copy of the license along with the program?

I guess it does not matter because somewhere it would still state
"this program is released under GPL" (as you said there is no version
number) so receient can look up what versions of GPL were ever released.

This is different from attaching a specific license.

> 
> >> even though the license itself 
> >> says otherwise?
> 
> > License does not say otherwise. License says that if there is an
> > _additional_ stipulation my the licensor then some other license
> > (non existing yet license) may be used.
> 
> No, you're referring to the portion you quoted, but I'm referring to
> another portion, that I quoted above.
> 
> > "If the Program specifies a version number of this License which
> > applies to it and "or BSD license", you have the option of following
> > the terms and conditions either of that version or of BSD license"
> 
> > would you still say that BSD is allowed by default by GPL? "GPL v2
> > and later versions" is not different from "GPL v2 or BSD" or
> > "GPLv2 or CDDL".
> 
> Agreed.  But this is not what this is about.  This is about the
> license saying something like:
> 
>   If the program does not specify a license version number, then
>   you're permitted to relicense the program under the BSD license.
> 
> Since the license file itself is not part of the program (if it were,
> a program under the GPL would require the GPL itself to be under the
> GPL, right?), I claim the program does not specify a license version
> number.
> 

Why don't you claim that actually the program is in public domain and
the license file just got there by mistake? Attaching a specific license
(and GPL v2 is a distinctive license, not a bumped up version of other
license) places work under this (and only this) license. In my book
this is different form just saying "the program is under GPL".

I guess we'll have to agree to disagree.

-- 
Dmitry
