Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZFLMRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZFLMRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZFLMRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:17:08 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:49176 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZFLMRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QIouZU3yq7qiXZNNaE/0dLaL7PyS7U2wr5MYWFFd1VwoZ4cbG0VXWHkkg5Bkxrf+4T
         YyLDpIZTYS0vHn8ODy13jlX+euoltmeY7HP7WRZ0qoqfd1o0fJvLYRavBg/5nWKhS5pJ
         pdX5Aw6DOsh6UAE8ZzCpQ01YVt7rDabnRTE10=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: HTC Dream aka. t-mobile g1 support
Date: Fri, 12 Jun 2009 10:39:43 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090611-07944-gc1b019d-dirty; KDE/4.2.3; i686; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611164218.GA21128@n2100.arm.linux.org.uk> <20090612012304.GA25550@shareable.org>
In-Reply-To: <20090612012304.GA25550@shareable.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906121039.44524.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009 03:23:04 Jamie Lokier wrote:
> Russell King - ARM Linux wrote:
> > On Thu, Jun 11, 2009 at 06:37:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > "No reason given" part was just lovely..
> > > 
> > > After getting a couple of such messages I decided to stay as far away from
> > > linux-arm-kernel list as possible..
> > > 
> > > Before interacting with linux-arm-kernel list I really thought that people
> > > exaggerated the issue and that their complains were unfounded..
> > 
> > I wish people told me about this - it's certainly not my policy nor
> > indeed the policy which should be applied to the list.  I'll find out
> > what's going on when my co-list admin returns from his vacation.
> > 
> > Thanks for bringing it to my attention.
> 
> Before I subscribed to linux-arm-kernel, I had quite a few moderation
> messages just because I responded to threads which included
> linux-arm-kernel in the addresses, but were cross-posted (by others)
> to say linux-kernel, uclinux-dev or linux-embedded.
> 
> I got moderation messages, and found them slightly annoying because
> I'd put effort into my replies, and presumed that some people involved
> in the thread wouldn't see them.  Possibly the important people.
> 
> That's the main reason I subscribed to linux-arm-kernel - just so I
> know people can see replies to threads that I'm responding to on other
> lists.
> 
> I do actually work on ARM kernels too, so don't unsubscribe me for that :-)
> 
> When I did subscribe to linux-arm-kernel, I got a message telling me I
> was being considered...  Months went by, and it didn't subscribe me.
> That was annoying.  I presumed I'd been rejected.
> 
> I tried again a few months later, and this time the subscription
> approval process was relatively quick at a week or so.  I was
> beginning to think I'd be silently rejected again, therefore delighted
> to be counted among the Special Ones allowed to subscribe :-)

:)

Now imagine a new or a seasonal ARM developer waiting a week just to be
able to post an obvious bug fix patch.  In most other kernel areas such
patch would be long applied.

The irony of this all is that the same people that complain about lack of
time still invest it in such idiotic tasks like approval of subscription
requests or moderation of messages..
