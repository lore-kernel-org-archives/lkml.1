Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbXFQTc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbXFQTc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbXFQTcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:32:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647AbXFQTcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:32:51 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Michael Poole <mdpoole@troilus.org>, Bron Gondwana <brong@fastmail.fm>,
       linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706170008.17477.dhazelton@enter.net>
	<87sl8qwusg.fsf@graviton.dyn.troilus.org>
	<200706171418.38844.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 16:32:34 -0300
In-Reply-To: <200706171418.38844.dhazelton@enter.net> (Daniel Hazelton's message of "Sun\, 17 Jun 2007 14\:18\:38 -0400")
Message-ID: <or7iq2gywd.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Sunday 17 June 2007 09:54:39 Michael Poole wrote:
>> What in the world makes you think there is a useful analogy
>> between communication standards and copyright licenses?

> I don't. I was *REPEATING* an example of how TiVO has a *RIGHT* to
> change the kernel or any other facet of the device connecting to
> their network. That right *ISN'T* tied to copyright - as you have
> stated. Since it isn't, why is the FSF trying to mandate that it is
> with the tivoization clauses in GPLv3?

Since you're talking about rights, and that's a legal term, and we've
(hopefully) already established that intent of license author, intent
of copyright holder and letter of the license are different concepts,
and only the last of the 3 has to do with legal terms, I'll excuse
myself from the plane of spirits ;-) and get down to legal terms to
shoot down your argument.


Let's see...  US law states that (paraphrasing), if you grant a
copyright license that says the person can do such and such, you can't
later turn to that person and say "oh, BTW, I have this patent, and it
means you couldn't do such and such in the first place, unless you pay
me a gazillion bucks"



Patents have nothing to do with copyrights.  Still, a copyright
license can (and does) limit the ways in which you can use the power
that patent law gives you.

You could try to argue that "you have a right to the patent, and to
use it however you like".  But the moment you accept a license such as
v1, v2, or any later version to be published by the FSF, you give up
the power to use that patent to stop users from fully enjoying the
freedoms that the license granted them and said you couldn't further
restrict.


s/patent/anti-circumvention measure/

s/patent/hardware/


See?


Now, why would we be revising the license, if it's all already there?

First of all, to make this all clear.

Second of all, because law does not operate this way.  While there is
case law that establishes that copyright law supersedes patent law in
this sense (or so I'm told, I don't have the references and IANAL),
it's not clear that the same would hold for the DMCA, or technical
measures, or even discriminatory agreements.

So, in order to provide users with a better defense against these
dangers for the freedoms, the newer revision clarifies them, such that
whoever attempts to deny users' freedoms has a weaker defense for such
attempts, in a copyright infringement lawsuit.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
