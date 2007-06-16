Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbXFPIkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbXFPIkv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 04:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbXFPIkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 04:40:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbXFPIkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 04:40:42 -0400
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Bernd Paysan <bernd.paysan@gmx.de>, Paulo Marques <pmarques@grupopie.com>,
       Al Viro <viro@ftp.linux.org.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706152325.14244.dtor@insightbb.com>
	<ory7iksgip.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706160117.02459.dtor@insightbb.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sat, 16 Jun 2007 05:40:00 -0300
In-Reply-To: <200706160117.02459.dtor@insightbb.com> (Dmitry Torokhov's message of "Sat\, 16 Jun 2007 01\:17\:01 -0400")
Message-ID: <or8xaks36n.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2007, Dmitry Torokhov <dtor@insightbb.com> wrote:

>> >> Then, any redistributor adds a copy of any version of the GPL (because
>> >> you didn't specify a version number).  At this point, is the program
>> >> licensed by *you* only under this specific license?
>> 
>> > If they did not make any changes then they have to include the earliest
>> > version of GPL that applies.
>> 
>> Why?  Why does it have to be the earliest?

> Earliest is wrong I suppose. What I meant is post permissive.

Again, why?  In the absence of a version number, why wouldn't the
redistributor choose any one he liked?

> I guess it does not matter because somewhere it would still state
> "this program is released under GPL" (as you said there is no version
> number) so receient can look up what versions of GPL were ever released.

Yes.  The initial recipient knows that, because he received the
announcement by e-mail, where the "released under GPL" was.  But how
about downstream recipients?  (yeah, I'm filling in blanks and making
this up on the fly, I hope you don't mind)

> This is different from attaching a specific license.

How can the downstream recipient tell this case from the case in which
you attached one specific version of the license and didn't write
anywhere that only that version applied?

> Why don't you claim that actually the program is in public domain and
> the license file just got there by mistake?

License file there by mistake is a possibility, but this wouldn't make
the program public domain, it would rather turn actions controlled by
copyright law into copyright infringement, but as long as the
recipient acted within the unclear intent of the licensor, the
licensor probably wouldn't enforce the license anyway.  And then, if
he did, there'd be a number of defenses available for the
licensee/infringer.  But IANAL.

> Attaching a specific license (and GPL v2 is a distinctive license,
> not a bumped up version of other license) places work under this
> (and only this) license.

We'll see if that works when someone tries to takes advantage of any
of the holes in GPLv1 that GPLv2 plugged and you try to enforce
GPLv2.  I'm not sure whether to hope it will (such that this implied
v2 gets better freedom protection than v1) or won't (such that I could
redistribute under v3 ;-)

> In my book this is different form just saying "the program is under
> GPL".

I hope you've consulted a lawyer about this.  If not, it might be
safer to state your intentions more explicitly, like Linus did.

> I guess we'll have to agree to disagree.

Works for me ;-)

Best regards,

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
