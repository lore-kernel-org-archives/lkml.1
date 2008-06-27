Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYF0QyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYF0QyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYF0QyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:54:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYF0QyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:54:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cH4NsQc5xcuAK7Hjk7Y9D2IVgDnCa2mK4VxTmcBSD3NY6XhEY0It9lUuX623oWrti
	XLv+ZaRSS+NeXaVLDaOBw==
Message-ID: <da824cf30806270953q1ebe62fx4face15e12edcc99@mail.gmail.com>
Date: Fri, 27 Jun 2008 09:53:46 -0700
From: "Grant Grundler" <grundler@google.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [Ksummit-2008-discuss] KS Topic Proposal: Vendor and User problems with the Kernel
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1214583706.3394.58.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214583706.3394.58.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 9:21 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> This proposal is a bit different from a concrete topic, but it's based
> on the generally positive feedback from the end user panel last year.
> It's to allocate 2h of Kernel summit to discuss problems raised by
> vendors and end users.  The format I'm proposing is 10 minutes of
> problem introduction by someone from the vendor or user representative
> who is a subject matter expert and 20 minutes of discussion (so,
> hopefully four such problems).
>
> As usual, the difficulty is actually finding people from the vendor and
> user community willing to do such a presentation (and ensuring they
> won't simply want to talk about their problems with X distro enterprise
> kernels).  The way I think we might get some diverse problems is to send
> out a call for participation.

I think this is a good idea and I suggest using referrals since it's not
just about the problem. It's also how it's presented. And it would be
worth a few $K to pay for a good presenter who has something relevant
to say. e.g. enough to cover travel/hotel plus something extra.

Secondly, these problems arise because second tier users aren't
participating in the development. I see this CFP as a "Call For Participation"
and not a "call for papers".

I also suggest trying to get representatives from different communities.
e.g. education, handhelds, desktop (something other than gfx drivers,
maybe revisit the user visible latency issues), HPC, database, etc.
I left out "embedded" since that's now too vague, has been flogged
to death in the past, and I _hope_ now has better participation.

The last issue I see is "Vendor" usually means HW vendor with a few
major SW vendors (e.g. Oracle, SAP). Those guys have sufficient
representation and I think some newer, smaller players (e.g. not google)
would be more interesting to invite. Maybe dreamworks, pixar, or
Ernie Ball Guitar Strings (http://www.ernieball.com/) might be examples.

hth,
grant

> Something like.
>
> "The kernel summit programme committe is inviting proposals for
> participation in the 2008 Kernel Summit in Portland Oregon (URL) from
> members of the End User and Vendor communities wishing to raise
> particular issues or problems they see with the current Linux Kernel.  A
> good problem presentation should stimulate discussion with the kernel
> community, and as such the presenter should be a subject matter expert
> capable of engaging in the debate.  While the presenter may have a
> preferred solution, they should concentrate on the problem and be
> prepared to consider the effects of solutions outside of their preferred
> one.  It goes without saying that problems should have a significant
> component which is susceptible to a solution within the Linux Kernel.
>
> "Proposals of around 500 words and describing the nature of the problem
> and the credentials of the presenter should be forwarded to the Linux
> Kernel Programme Committee at
> <ksummit-2008-pc@lists.linux-foundation.org>"
>
> Obviously we'd have to circulate this beyond the usual mailing lists,
> but we can solicit help from the Linux Foundation to do this.
>
> James
>
>
> _______________________________________________
> Ksummit-2008-discuss mailing list
> Ksummit-2008-discuss@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/ksummit-2008-discuss
>
