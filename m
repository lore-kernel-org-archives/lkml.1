Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbYG1SUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbYG1SUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYG1ST7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:19:59 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:57977 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYG1ST6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kNA3vtHlTSgVBvwfWF62Dwx6YZhrWaLw4A4QiVVlYVcntf/LvBmAzecu3kSGzkbeiF
         pzyH1ZNED4eXzz4oa0GW/1RsXYiqeRmuDBPgToBs2X4nXqY2xxB5A5q5Dsm1jw/pGZuE
         M5hgOpH92YhZtH8u8w3sjPJekWdna8/vfOkis=
Message-ID: <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com>
Date: Mon, 28 Jul 2008 14:19:56 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: 463 kernel developers missing!
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <488E0BB6.7020006@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
	 <488DF9CF.8020408@simon.arlott.org.uk>
	 <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>
	 <488DFD97.7080802@simon.arlott.org.uk>
	 <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com>
	 <488E0BB6.7020006@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Simon Arlott <simon@fire.lp0.eu> wrote:
> On 28/07/08 18:22, Jon Smirl wrote:
>
> > On 7/28/08, Simon Arlott <simon@fire.lp0.eu> wrote:
> >
> > > On 28/07/08 18:05, Jon Smirl wrote:
> > > > On 7/28/08, Simon Arlott <simon@fire.lp0.eu> wrote:
> > > > >  Just because anyone can grep the kernel log for email addresses [to
> > > send
> > > > > spam to], doesn't mean that you need to do it for them.
> > > > >
> > > >
> > > > You need to be in the file since you have submitted patches using
> three
> > > aliases.
> > > >
> > >
> > >  No, I've submitted patches using three email addresses (well, two - one
> is
> > > a typo).
> > >
> >
> > That's the whole point of this list. When you submit patches in the
> > future we can check your name/email against the list and flag it if it
> > isn't there. That will alert you that you've made a typo.
> >
>
>  I don't make typos in my name or email address.

You just admitted six lines early that you made a typo.

> > A later version of this list could separate the valid current
> > names/addresses from the entries that are fixing typos or that have
> > old emails. That would improve the validation. But I don't have an
> > automated way to tell me which alias is the current one. Access to the
> > current LKML subscriber list would supply the needed info as to which
> > one to pick.
> >
>
>  Validation of what?
>  The current alias is the most recent active one.
>
>  I'm not subscribed to the LKML with a public address.
>  Please Cc: me if you submit a patch for this so I can add a Nacked-By:
> and/or cleanup the list by removing redundant entires. Even if git-shortlog
> is changed to distinguish between people who share the same name, it would
> still be a list of exceptions rather than everyone.

Comparing to LKML subscribers would not be used to generate new email
addresses. It would only help to identify which existing alias is your
current one.  But we don't have to do it that way, I can use the email
of your most recent commit as your current address and you can fix it
if it is wrong. Only email addresses that appear in the kernel log
should appear in the mailmap file.


>
>  --
>  Simon Arlott
>


-- 
Jon Smirl
jonsmirl@gmail.com
