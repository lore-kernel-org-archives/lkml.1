Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYG2J7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYG2J7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYG2J7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:59:13 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:34164 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754393AbYG2J7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:59:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BkD5LE+SJdnDYNzSVFsvhixPLsym5eo/sj0Lj73wsmFe/0l279C1gR9Q9x75L8febzFsjuv+JVoZ+peaLzerbM2nbahy34McbQDRSbDuXx+seyuNXmRg5kMmvBs9Jk/o9WrPzqTt8ETH1PLtJsLwhG9gl+YTLI2/mTpJ+356AWs=  ;
X-YMail-OSG: 4rYMooUVM1nbBF19mp55gwL7fAwLX8mzQgy0qFrmPDJ3jfxgXw0PK3TtOvNUINQsm48T7Ir6Te3JSnBUl76tSHv0JMkMlANjEzCocvWdBroLjjE6Sv_qiYgSUc4zuQtgYZk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Jones <davej@redhat.com>
Subject: Re: 463 kernel developers missing!
Date: Tue, 29 Jul 2008 19:58:52 +1000
User-Agent: KMail/1.9.5
Cc: Theodore Tso <tytso@mit.edu>, Jon Smirl <jonsmirl@gmail.com>,
       Simon Arlott <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com> <20080728202236.GN9378@mit.edu> <20080728204624.GA11581@redhat.com>
In-Reply-To: <20080728204624.GA11581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291958.52650.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 06:46, Dave Jones wrote:
> On Mon, Jul 28, 2008 at 04:22:36PM -0400, Theodore Tso wrote:
>  > On Mon, Jul 28, 2008 at 03:00:13PM -0400, Jon Smirl wrote:
>  > > Other people aren't perfect, I've found over 1,000 typos in the those
>  > > names and emails. We need a validation mechanism.
>  >
>  > You keep using the word "need"; I do not think it means what you think
>  > it does.  :-)
>  >
>  > Seriously, why is it so important?  It's a nice to have, and I
>  > recognize that you've spent a bunch of time on it.  But if the goal is
>  > to get better statistics, and in exchange we forcibly map all Mark
>  > Browns to one e-mail address, and/or force them to all adopt middle
>  > initials (what if there are two Dan Smith's that don't have middle
>  > initials) just for the convenience of your statistics gathering, I
>  > would gently suggest to you that you've forgotten which is the tail,
>  > and which is the dog.
>
> I'm beginning to question just how useful the continued measuring
> of things like Signed-off-by's is.   Last week at OLS, I overheard
> a conversation where someone was talking about the "top 10" lists
> that Greg has been talking about at various conferences.
> The conversation went along the lines of "my manager really wants
> to see us on that list, at any cost".
> Whilst the niave may think 'more patches == more better', this isn't
> necessarily the case given we have nowhere near enough review bandwidth
> *now*

This is one way of looking at "the problem". The other way to look at
it is that things are merged too quickly / without enough review, etc.

That is the problem kernel maintainers can actually do something about.
Or, they can just whine about "not enough review bandwidth".

There has been this complaining from lots of people about not enough
review bandwidth for quite a few years now. So I doubt it is going to
magically get better by making more noise.

Consider that there is probably virtually limitless amount of crap that
people want to try to merge, so there is always going to be a lack of
review bandwidth if the aim is to merge as much as we possibly can as
fast as we can.

The answer is to not make the problem worse by merging stuff faster
than can be reviewed. When that happens, developers and companies
should eventually assign a higher value to patch review.
