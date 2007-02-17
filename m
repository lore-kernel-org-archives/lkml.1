Return-Path: <linux-kernel-owner+w=401wt.eu-S1946723AbXBQN1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946723AbXBQN1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 08:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946725AbXBQN1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 08:27:46 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4767 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946723AbXBQN1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 08:27:45 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: GPL vs non-GPL device drivers
Date: Sat, 17 Feb 2007 05:27:12 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEJLBKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <orire1s39s.fsf@free.oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 17 Feb 2007 05:27:33 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 17 Feb 2007 05:27:35 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(combined responses)

> On Feb 17, 2007, "David Schwartz" <davids@webmaster.com> wrote:
>
> >> Linking with kernel exported symbols in a kernel module is by many
> >> people considered creating a work derived from the kernel.

> > That's simply unreasonable. It is the most clear settled law that only a
> > creative process can create a work for copyright purposes. Linking is an
> > automated process, not a creative process. It cannot create a
> > work at all,
> > much less a derivative work.

> Per this principle, it would seem that only source code and
> hand-crafted object code would be governed by copyright, since
> compilation is also an automated process.

You misunderstand what I'm saying. If you have two works, A and B, and
neither is a derivative work of the other, linking the two of them together
does not create a new work, so it cannot create a derivative work. The
result still could be work A or work B (or both of them).

If you make a copy of a disk, you have not created a new work. However, the
result of that copy is still the original work.

As a more accurate example, suppose I take a DVD of The Phantom Menace and
convert it to AVI format. The result is not a new work for copyright
purposes, it's just The Phantom Menace. If I take The Phantom Menace and The
Big Lebowski and put them in a program that alternates frames, the result is
not a new work (unless you can argue there was some creativity in choosing
to combine those two works) but is simply The Big Lebowski and The Phanton
Menace, just as if I had put the two DVDs in one box.

> > If you have two works, A and B, and neither is a derivative work of the
> > other, linking them together cannot change the status of A or B.

> IANAL, but I understand this is correct.  However, the output is
> probably a derivative work of both.

That cannot be, because the output is not a new work. Only a creative
process can create a new work.

> Also, it's the fact that A needs to be linked with B, or vice-versa,
> that's a clue that A is likely to be a derived work from B, or
> vice-versa, even before they're linked together.

Correct. That is a separate argument that certainly might be reasonable
under some circumstances. We're dealing with two seprate arguments here, one
reasonable and one unreasonable. The reasonable one (though I think it's
incorrect here) that if you use EXPORT_SYMBOL_GPL symbols, your code likely
has so much knowledge of (and code from) the Linux kernel that it must be a
derivative work. The unreasonable one is that linking creates a derivative
work. No automated process can create a new work for copyright purposes.

And on to the other argument:

> So, since there's no other way to do Yesterday, exactly as performed
> by the Beatles in the 1965 album Help!, I'm free to copy it, perform
> it, create derived versions thereof and perform them, without paying
> royalties to the current copyright holders?

I disagree with the premise, but even assuming it were true, the answer is
no. First, you cannot compare functional works to non-functional works in
this context because this exception is specifically about functional works.
But second, the premise is wrong.

You are correct that there is no other way to express this idea this way.
But that is always true of any work. However, there are other ways to
express the same idea. (Not precisely the same. Arguably if you change the
name of Romeo to Robert and leave everything else in Romeo and Juliet the
same, it's a different idea.) I agree that this distinction (between an idea
and an expression) is not always perfectly clear in copyright, but these are
two cases where it *is* clear.

> One could always create a clean-room implementation of kernel headers
> and use them to build a module that presumably wouldn't be a derived
> work, as long as the binary is indeed created using these clean-room
> headers.  But who does that, considering how quickly kernel headers
> change, and that if you build the object code using the actual kernel
> headers, then the binary is likely to be a derived work of the kernel,
> even if the sources still aren't?

The fact that this is impractical and it's the only other way to accomplish
the same function proves that you don't need to do it. Copyright does not
allow you to own every practical way to achieve a function or even express
an idea.

DS


