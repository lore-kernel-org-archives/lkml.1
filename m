Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbXFSXv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbXFSXv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbXFSXvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:51:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634AbXFSXvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:51:20 -0400
To: "David Schwartz" <davids@webmaster.com>
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKAELIELAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 20:51:10 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAELIELAC.davids@webmaster.com> (David Schwartz's message of "Tue\, 19 Jun 2007 15\:40\:54 -0700")
Message-ID: <orps3ry041.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> Right to control what software runs on the hardware is no different.
>> For any hardware on which I can run the software, I'm a user there,
>> and I'm entitled to the rights granted by the license.

> Exactly. However, that right does not include the right to run the software
> on any particular piece of hardware.

I think that's correct, in general.  But when I receive the software
along with a particular piece of hardware, on which I'm to expected to
run it, I'm also receiving all other freedoms that ought to be
respected by whoever distributed the software to me, which means the
distributor can't impose restrictions on my running modified versions
of the program there (or anywhere else I can run the software, for
that matter).

> It includes the right to run the software on *ANY* hardware, so long
> as one is authorized to choose what software runs on that hardware.

That's correct, too, with the provision that the distributor cannot
impose restrictions on running modified versions of the program.  Not
on any other hardware I can control, not on the hardware with which I
received the software along with the freedoms to control it in as far
as running the GPLed software goes.

> You keep conflating things like access to the source code and the legal
> right to modify that source code with the authorization right to install
> that modified kernel on some particular piece of hardware. The GPL was never
> about how such authorization decisions are made.

That's correct.  All it says is that you can't impose further
restrictions.  This means you can't use anything (source code
deprivation, patents, copyright, authorization, nothing) to disrespect
users' freedoms.  Is this so hard to accept?  There's nothing special
about these authorization rights you're talking about that distinguish
them from copyrights or patent rights or any other rights.  The GPL
says: don't use them against users' freedoms regarding the GPLed
software.  No excuses.

> If I make you a user of my laptop, do I have to let you install a modified
> kernel?

Does interacting with your laptop over the network make me a user of
your kernel?

> What if I even let you access the kernel source, so I have
> distributed it to you.

You have distributed the source to me, I can modify it.

But did you distribute the kernel binary installed on your computer to
me?  That's the one I'm (possibly) using per the above.  Whether you
also gave me sources is irrelevant, unless you gave them to me as part
of your obligation of distributing the corresponding sources, in case
we conclude you distributed the kernel binary installed on your
computer to me when you granted me remote access to it.

And then, GPLv3 makes it clear that, in the case of remote access,
you're not conveying the binary to me, therefore the conditions for
conveying do not apply.

> The GPL was never, ever about such authorization decisions. They are
> completely alien to both the wording and the spirit of the GPL.

You can repeat that as much as you want, this won't change the fact
that the GPL has never permitted you to use whatever rights you have
to impose restrictions on users' freedoms as to GPLed software once
you've (implicitly) accepted the conditions of the license.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
