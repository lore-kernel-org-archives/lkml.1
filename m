Return-Path: <linux-kernel-owner+w=401wt.eu-S964887AbXBPQ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887AbXBPQ64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964889AbXBPQ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:58:56 -0500
Received: from smtp107.sbc.mail.re2.yahoo.com ([68.142.229.98]:36714 "HELO
	smtp107.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964887AbXBPQ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:58:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=QR09/MkrG67u7MF6IWHDSVwN2MBnv4TNmoj/JFxUX5EuAfQOLbrqb616VfySp9IWyHGICqAoSOBg9EGwmj94wnvKI1nZwlKBklusuq+5dcKmfJI8E7jdiH1LAZY64mDmgGcdtS5UJJJH4qpMgn0fsSpukijo8gyqjrdBaPzqrsM=  ;
X-YMail-OSG: x5vrEFUVM1n90XQr8_bC9YRGnhqA5WO0OST4jBnDbvDG0AJlbTyrfO64Iqsb86StbFu8.DmBSk4fO9P0NPyCzmNp3yoDAvxudsBpeBjfxhi1YGtUap8a_2uamC6GODc_n0vVvvvt6jJu3nU-
Message-ID: <45D5E321.3080805@sbcglobal.net>
Date: Fri, 16 Feb 2007 11:00:17 -0600
From: Matthew Frost <artusemrys@sbcglobal.net>
Reply-To: artusemrys@sbcglobal.net
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: v j <vj.linux@gmail.com>
CC: Scott Preece <sepreece@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>	 <20070215061149.GE15654@redhat.com>	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>	 <20070215165339.GB5285@thunk.org>	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>	 <7b69d1470702151705h297c3b38g138eb0138b900aea@mail.gmail.com> <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
In-Reply-To: <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v j wrote:
> On 2/15/07, Scott Preece <sepreece@gmail.com> wrote:
>> On 2/15/07, v j <vj.linux@gmail.com> wrote:
>>> So far I have heard nothing but, "if you don't contribute, screw you."
>>> All this is fine. Just say so. Make it black and white. Make it
>>> perfectly clear what is and isn't legal. If we can't load proprietary
>>> modules, then so be it. It will help everybody if this is out in the
>>> clear, instead of resorting to stupid half measures like
>>> EXPORT_SYMBOL_GPL.
>> ---

You are asking developers to make a statement which is not theirs to make.
"Legal" is a jurisdictional variable.  Its meaning is interpreted by the law
codes of whatever jurisdiction you or your company operate within.  You may be
subject to the interpretations of alternate jurisdictions by the scope of your
actions and their effects, personally or corporately.  A general statement of
"legal" with respect to this issue has been described to you, but is ultimately
a result of several factors, the principal of which are the binding legal
instrument governing permissible behavior with respect to the code in Linux and
the legal environment within which your actions under that instrument can be judged.

I want you to consider that Linux is a licensed software product subject to
copyright constraints.  That provides two legal conditions for use of Linux.
The privilege of using Linux for your particular purpose comes at the cost of
respecting the rights of the copyright holders in the work, based upon the
licensing conditions established for that work.  In this respect, it is no
different than any other software package that your company evaluated.

In your evaluation of the respective benefits and costs to the selection of a
given software package for your embedded environment, you should already have
consulted counsel about the legal ramifications of licensing restrictions for
the available options.  They should have informed you that the GPL, as a legal
instrument, binds your scope of action.

You state in your initial comment that you "chose Linux ... because of its lack
of royalty model, robustness and availability of infinite number of open-source
tools."  From your limited description, it sounds as though you believed that
the benefits for use of Linux as a distributable operating system for your
embedded platform were not balanced by costs beyond in-house development.  Linux
is, indeed, free with respect to any monetary royalty.  This does not mean that
there are not costs associated with its use; it merely means that the monetary
outlay for use is far smaller than that required by many of its competitors.  In
general terms, that monetary outlay can be spent in-house, rather than lost to
an outside company.  However, that limited view of costs fails to take into
account the very real demands placed by the license constraints.

You are required, as with any copyrighted and licensed software product, to
comply with the terms of the license and their ramifications in the legal
environment.  These ramifications do change as the environment in which your
company does business changes.  This is why most companies retain counsel.  If
your legal advisers are of the considered opinion that your actions with respect
to the license constraints governing Linux are legally defensible, you have your
answer.

> Which statement are you talking about? First of all it is not clear to
> me if proprietary modules need to be GPL or not. If they do, I guess I
> have nothing to say. If that is the way developers want it, so be it.
> 
> Assuming these need not be GPL, I have a problem with
> EXPORT_SYMBOL_GPL and the general trend in the direction of making
> proprietary drivers harder on companies. Our drivers use basic
> interfaces in the kernel like open, read, write, ioctl, semaphores,
> interrupts, timers etc. This is functionality we would expect from any
> operating system. We used devfs before and had no problems there. Greg
> KH has gone and made the basic sysfs interface, which any generic
> driver could use as EXPORT_SYMBOL_GPL. I don't really care, I just
> don't use sysfs. The point is that old functionality is being ripped
> off and new ones introduced, and their interfaces are not open
> anymore. Hence there will be a point where non-GPLed drivers simply
> cannot be loaded.
> 
> So why beat about the bush? Just make it illegal to load proprietary
> drivers, or remove EXPORT_SYMBOL_GPL.

The kernel developers, collectively the holders of the copyrights in the work
under consideration, continue to perform actions deemed necessary or useful to
prevent circumvention of those licensing constraints.  In this way, they defend
their work, and their rights in that work, from violation by third parties with
agendas incompatible with the principles represented in the chosen license.

Under most legal definitions, violation of license constraints with respect to a
copyrighted work at the very least compels one to refrain from using said work.
 The continued implication that Linux would be injured because you refrain from
violating its license by ceasing to use and distribute Linux in a manner which
is out of compliance with its license is risible.

By all means, consult a lawyer and use Linux in compliance with the license and
your particular relevant legal framework.  But don't ask kernel developers
what's "legal".  They have already told you that in the license.  Perform your
due diligence.

> 
> vj.
> -

Matt Frost
