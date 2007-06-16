Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbXFPDwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbXFPDwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 23:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbXFPDwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 23:52:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbXFPDwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 23:52:34 -0400
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Bernd Paysan <bernd.paysan@gmx.de>, Paulo Marques <pmarques@grupopie.com>,
       Al Viro <viro@ftp.linux.org.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<d120d5000706151146u6f69667eodd2ff3f5e857a917@mail.gmail.com>
	<or8xalx6vu.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706152325.14244.dtor@insightbb.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sat, 16 Jun 2007 00:51:58 -0300
In-Reply-To: <200706152325.14244.dtor@insightbb.com> (Dmitry Torokhov's message of "Fri\, 15 Jun 2007 23\:25\:13 -0400")
Message-ID: <ory7iksgip.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2007, Dmitry Torokhov <dtor@insightbb.com> wrote:

> On Friday 15 June 2007 17:08, Alexandre Oliva wrote:
>> >> If the Program does not specify a version number of this License,
>> >> you may choose any version ever published by the Free Software
>> >> Foundation.

> Distributing a copy of GPL is not a requirement for me as a licensor
> however I did chose to include a copy of a specific version of a
> specific license and did not make any other statements that is the
> license for the work.
 
And the copy you chose to include says the above.

Are you absolutely sure you could terminate the license of a
distributor that refrains to pass on a patent license it obtained, if
you included a copy of the GPLv2 without any other indication that
you're choosing GPLv2 and no other version of the GPL, in spite of the
above?

Would it change anything if you had released the program back when
GPLv3 wasn't under discussion, and GPLv1 was long forgotten, so most
people (yourself included) only referred to it as GPL, or GNU GPL?

>> Then, any redistributor adds a copy of any version of the GPL (because
>> you didn't specify a version number).  At this point, is the program
>> licensed by *you* only under this specific license?

> If they did not make any changes then they have to include the earliest
> version of GPL that applies.

Why?  Why does it have to be the earliest?

>> even though the license itself 
>> says otherwise?

> License does not say otherwise. License says that if there is an
> _additional_ stipulation my the licensor then some other license
> (non existing yet license) may be used.

No, you're referring to the portion you quoted, but I'm referring to
another portion, that I quoted above.

> "If the Program specifies a version number of this License which
> applies to it and "or BSD license", you have the option of following
> the terms and conditions either of that version or of BSD license"

> would you still say that BSD is allowed by default by GPL? "GPL v2
> and later versions" is not different from "GPL v2 or BSD" or
> "GPLv2 or CDDL".

Agreed.  But this is not what this is about.  This is about the
license saying something like:

  If the program does not specify a license version number, then
  you're permitted to relicense the program under the BSD license.

Since the license file itself is not part of the program (if it were,
a program under the GPL would require the GPL itself to be under the
GPL, right?), I claim the program does not specify a license version
number.

Now what?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
