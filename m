Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbXF1Doi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbXF1Doi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761109AbXF1Dob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:44:31 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3229 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759994AbXF1Doa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:44:30 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Date: Wed, 27 Jun 2007 20:44:21 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEELNEOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <ory7i4zykp.fsf@oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 27 Jun 2007 20:44:19 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 27 Jun 2007 20:44:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Alexandre Oliva writes:
>
> >> Yes, but in the scenario I proposed, the source code *is* in the
> >> preferred form for making modifications, it just so happens to be
> >> behind a barrier you cannot trespass.  This is not different from
> >> shipping binaries and sources in a CD inside a locked box that you
> >> can't open.  You've received both, but how is the fact that you can't
> >> reach the source code (or the binaries) a violation of the GPL in this
> >> case?
>
> > Behind a barrier is not the preferred form for modification.
>
> Where does it state that there must not be a barrier?  I see it saying
> the source must accompany the binary, under 3a.
>
> > Encrypted with a key you don't have is not the preferred form for
> > modification.
>
> Indeed, but why does it matter?  In a CD is not the preferred form for
> making modifications either.  In fact, in the CD, you can't modify it
> at all.  What's *behind* encryption is the source code, along with the
> binary it accompanies.
>
> >> And, if it's not a violation, what is it that makes the case of
> >> shipping programs in a locked enclosure different from shipping them
> >> in a locked computing device?
>
> > I honestly don't see what relevance this could possibly
> > have. Getting access to the source is a fundamental GPL right.
>
> That's the spirit.  But where does the *letter* of the GPL state it?

I stand by my claim that any obstacle to obtaining and modifying any copy of
the source code (and thus encumbering your ability to use it at all) would
be a violation of both the letter and the spirit of the GPL. (As expressed
in section 3.)

Until someplace you can't actually access the software is customarily used
for software interchange, ...

But I fear that your interpretation of section 7 is mostly correct. This is
a defect in the GPL. At least as I understood it, the intent was to force
distributors to remove any code for which there was a patent claim that
might threaten redistribution. Section 7 fails to do that.

While you are granted rights under copyright, section 7 does not prevent
people from using other laws (so long as they don't impose the restrictions
or agree to them) to hamer your right to redistribute (or for those who
receive a distribution from you to lawfully use the work).

It is quite difficult to actually arrange this. You would need something
like a third party to indemnify your customers without your having to agree
to such indemnification.

DS


