Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbXFVA6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbXFVA6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 20:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXFVA6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 20:58:43 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:51554 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXFVA6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 20:58:42 -0400
Date: Thu, 21 Jun 2007 20:58:34 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070622005834.GD602@delft.aura.cs.cmu.edu>
Mail-Followup-To: Alexandre Oliva <aoliva@redhat.com>, davids@webmaster.com,
	linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKEEINEMAC.davids@webmaster.com> <orvedgj3hu.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orvedgj3hu.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 08:23:57PM -0300, Alexandre Oliva wrote:
> On Jun 21, 2007, "David Schwartz" <davids@webmaster.com> wrote:
> 
> >> > Wouldn't that defeat the entire purpose of the GPLv3? Couldn't
> >> > I take any
> >> > GPLv3 program, combine it with a few lines of Linux code, and
> >> > Tivoize the
> >> > result?
> 
> >> No.  This is not permission to relicense.  This is permission to
> >> combine.  Each author still gets to enforce the terms of her own code.
> 
> > This makes no sense. We are not talking mere aggregation here, we are
> > talking developmental convergence. If I wrote some code that was in the
> > Linux kernel, how can I enforce the terms of my code (guaranteed write to
> > Tivoize) in the derivative work that it becomes mixed with?
> 
> In just the same way you'd enforce it today: with help from a lawyer
> who understands these issues that you clearly don't understand.
> 
> >> So a tivoizer would have to take out the code licensed under the
> >> GPLv3, and use only the code that permits tivoization.  Same as today,
> >> but without the possibility of cooperation for licensees who don't
> >> tivoize.
> 
> > I am baffled how this could possibly work. You understand that the GPLv2
> > specifically guarantees that any derivative work will be Tivoizable and the
> > people who chose the GPLv2 specifically want it that way?
> 
> Yes.  And the GPLv2 code would remain that way.
> 
> If GPLv3 had this provision I suggested, and you wanted to cooperate
> with some other project that offered GPLv3 drivers, then you could use
> them by adding the mutual-cooperation provision I suggested.
> 
> Of course you're free to not want to cooperate with anyone else who
> doesn't share your opinion.  That's your call.
> 
> > If I chose the GPLv2 over the GPLv3 as a conscious choice, that means I want
> > people to be able to Tivoize any derivative work made from my work that is
> > distributed.
> 
> This provision was not intended to prevent anyone from tivoizing your
> work or derived works thereof.  It was only intended to enable you to
> use code from GPLv3 projects as long as these GPLv3 projects could
> also use your code.  Mutual cooperation, as opposed to no cooperation
> whatsoever.
> 
> I *think* lawyers would probably recommend you to keep code under
> different licenses in separate files, like you already do with code
> licensed under GPLv2-compatible licenses.
> 
> I *think* that, with this pair of mutual cooperation provisions, you
> could even use code licensed under the Apache 2.0 license.  And
> OpenSolaris drivers, if it's licensed under GPLv3.
> 
> And you wouldn't be departing from your intent to enable people to
> tivoize your code, which you currently choose not to enforce even
> though GPLv2 might very well enable you to; you could keep on
> cooperating with people who understand GPLv2 doesn't permit
> tivoization, and you'd be able to establish mutual cooperation with
> people who choose a license that makes this point clear.
> 
> It's not like anyone can safely tivoize devices with GPLv2 already, so
> refusing to cooperate with GPLv3 on these grounds buys you nothing.
> It is only a public statement of refusal to cooperate, with you are
> entitled to make, even if it comes off as silly because you chose a
> license that already contains the provisions for "complete
> corresponding source code" and "no further restrictions on the
> exercise of the rights granted by the license" that tivoizers fail to
> comply with.

So you really didn't pay any attention to anything people told you?

Ok, here are the relevant parts from GPLv2,

  The precise terms and conditions for copying, distribution and
  modification follow.

		    GNU GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  0. ... Activities other than copying, distribution and modification
  are not covered by this License; they are outside its scope. ...
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  6. ... You may not impose any further restrictions on the recipients'
  exercise of the rights granted herein. ...
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  11. ... THERE IS NO WARRANTY ... INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE. ...
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The license does not grant the right that you will be able to run the
software on any particular platform or whether it will even work at all.

You are only granted the rights to _COPY_, _DISTRIBUTE_, and _MODIFY_.
Tivo in no way limits your ability to exercise any of these rights.

> FWIW, all of my (very few) contributions to Linux were made with the
> intent of not permitting tivoization or any form of restricting users
> freedoms.  I guess this means, from now on, you'd stop accepting my
> contributions and take out whatever contributions I've made, since

Only if the terms of your contributions are conflicting with the terms
of the GPLv2 and you are not willing to dual license your code. There is
no need to take out contributions because the GPLv2 does not prevent
tivoization.

Although you did license your code under the GPLv2 and as such gave the
permission to freely copy, distribute and modify, I think most kernel
developers will respect the wishes of the original author if he really
wants to have his code removed.

> So what exactly are you trying to accomplish by pretending that mutual
> compatibility with GPLv3 would set you back in any way?

GPLv3 adds additional restrictions, which the original authors did not
want to impose on their licensee's otherwise they would have licensed
(or would re-license) their code as GPLv2+.

A mutual compatibility agreement (sublicense) would effectively
terminate any rights granted by the GPLv2,

    4. You may not copy, modify, sublicense, or distribute the Program
    except as expressly provided under this License.  Any attempt
    otherwise to copy, modify, sublicense or distribute the Program is
    void, and will automatically terminate your rights under this
    License.
...
    7. If ... for any other reason ... conditions are imposed on you ...
    that contradict the conditions of this License, they do not excuse
    you from the conditions of this License.

Jan
