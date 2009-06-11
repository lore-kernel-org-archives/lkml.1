Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbZFKQci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbZFKQci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbZFKQcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:32:04 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:59684 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760883AbZFKQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=OkS6dkHoDjn9mbD5KpZi2vt6gct4SOENahGLY8LWUCDir5L+s0MsCqanrkr6aa4SPp
         7agfe7pd+yaAiaxiaXeGkXckWg3HmtDtBFZ5xklMTZ6ytPMZk7ykBwuTmKdSi2OLggmk
         nacRrzloCB0Tn/h8RE7BkGUTTA67+BI7oEsqc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: HTC Dream aka. t-mobile g1 support
Date: Thu, 11 Jun 2009 18:37:21 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090611-07944-gc1b019d-dirty; KDE/4.2.3; i686; ; )
Cc: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <1244735580.895.80.camel@Joe-Laptop.home> <20090611160850.GX795@n2100.arm.linux.org.uk>
In-Reply-To: <20090611160850.GX795@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906111837.21944.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009 18:08:50 Russell King - ARM Linux wrote:
> On Thu, Jun 11, 2009 at 08:53:00AM -0700, Joe Perches wrote:
> > On Thu, 2009-06-11 at 16:39 +0100, Russell King - ARM Linux wrote:
> > > On Thu, Jun 11, 2009 at 08:15:10AM -0700, Joe Perches wrote:
> > > > I suggest you stop using subscriber-only mailing lists and
> > > > use linux-arm@vger.kernel.org.
> > > It's difficult to see how that helps, given that these lists have
> > > 1800+ subscribers already on them.  If 1800 subscribers can't do it,
> > > are you expecting (maybe) another 100 to magically provide the answer?
> > 
> > There aren't large numbers of ARM posters.
> > 
> > You've simply put up an unnecessary roadblock to
> > getting patches for review.
> 
> I simply disagree with your assessment of the situation.  Yes, there are
> a few people who refuse to subscribe to such lists, but I maintain that's
> a fairly small proportion.
> 
> I'd also point out that most of the people in this thread aren't
> subscribed to this list, yet they're posting freely to it.  Some of the
> people posting to it will get a moderation message for a couple of times
> and then no more.  As I've said in the past, unlike most subscriber only

Interesting.

Here is the typical moderation message I was getting:

On Tuesday 17 February 2009 14:08:44 linux-arm-kernel-bounces@lists.arm.linux.org.uk wrote:
> Your request to the Linux-arm-kernel mailing list
> 
>     Posting of your message titled "Re: [PATCH 3/3 v3] AT91:
> initialize Compact Flash on AT91SAM9263 cpu"
> 
> has been rejected by the list moderator.  The moderator gave the
> following reason for rejecting your request:
> 
> "No reason given"
> 
> Any questions or comments should be directed to the list administrator
> at:
> 
>     linux-arm-kernel-owner@lists.arm.linux.org.uk

"No reason given" part was just lovely..

After getting a couple of such messages I decided to stay as far away from
linux-arm-kernel list as possible..

Before interacting with linux-arm-kernel list I really thought that people
exaggerated the issue and that their complains were unfounded..
