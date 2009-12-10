Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZLJTxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZLJTxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZLJTxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:53:30 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45253 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbZLJTx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:53:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=L5a1tNl2l+9/mm5I+J33IGsKZPM3KOZBcO1KUstqL3pGJQuhfiFP2NSRzO3syVFROB
         Fvq7JFej1DXcyuiMyahNJYZefsMb84Lj9QoKBwQ8STcEjgIklC/yrZ0ZibAAVa8PS6oh
         d3APTRl+mhb0Rw5UgFN6O+zx8tI33JdY1/ZSY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	 <1260459601.18520.26.camel@skunk>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
Date: Thu, 10 Dec 2009 20:53:34 +0100
Message-ID: <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
Subject: Re: [git pull] drm
From: Stephane Marchesin <stephane.marchesin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 19:42, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 10 Dec 2009, Maarten Maathuis wrote:
>>
>> You assume that Red Hat has full control over the project, which i
>> don't think is the case. The reason it isn't in staging yet (as far as
>> i know) is because of some questions over the copyright of some
>> (essential) microcode. Either the question needs to be answered, or it
>> has to be reverse engineered to the point that it's possible to
>> generate it.
>
> I think people are just making up excuses, as evidenced by the fact that
> you're quoting a different excuse than I've heard before.
>
> The fact is, if there are license questions, then Fedora had better not be
> distributing the code either. And they clearly are.
>
> And don't tell me about "full control". There's absolutely full control
> over it being included or not.
>
> When I brought this up at the kernel summit, there were various other
> random excuses. I think one of them was that it wasn't part of an official
> Fedora release (which is sure as hell not true at least as of Fedora 12).
>
> I've heard the "but it's hard to merge" excuse too - which I also know is
> bullshit, because I can look at the git tree Fedora apparently uses, and
> it merges without any conflicts what-so-ever.
>
> The most common excuse is the "oh, but it might change" crap. But that's
> not even a very good excuse to start with, and it's what staging is for
> anyway.
>
> Somebody even made the crazy comment that "but Fedora isn't a real
> distribution, so it doesn't need to follow the rules everybody agreed to
> several _years_ ago wrt merging stuff to mainline".
>
> I _think_ that last one was meant as a joke. But it's damn hard to tell,
> because the ones that are apparently sincere are equally crazy. People
> just seem to make up total crap to make excuses for something that
> everybody knows is wrong.
>

I'm not sure why people are arguing so much over this, given that no
nouveau devs were at the kernel summit, and we only heard rumours
afterwards that there were complaints about us not being ready for
merging.

If you have issues to raise about nouveau, please raise them on the
nouveau, mesa or dri lists, at least some time before starting to
complain. I must say I didn't think such a big issue was going on
here, that's the problem with rumours.

Stephane (nouveau founder).
