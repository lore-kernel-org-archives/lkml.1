Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbZIICIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbZIICIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZIICIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:08:43 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:54108 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZIICIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=T/nvEIGA8ewjlYSfPy+1TR6hoV3wmQUAi7ch7GIWy4dS7jVNshyskF2rBarNI45usi
         /uT2eKvmZdyB+5GWN2pCA8Ytm9x9F9SwexwjesEHW2RgTe1Xm5Nzv7aWSXThOePrpgiw
         GJKSfcGdzmtMAmlKUY7+Z69OwkQlz9P+YqmrM=
MIME-Version: 1.0
In-Reply-To: <20090908230416.GA8283@kroah.com>
References: <43e72e890909081230h420c2abi125a6fbfc2777250@mail.gmail.com> 
	<43e72e890909081244m4083a1bcq30cf1306ce566726@mail.gmail.com> 
	<20090908230416.GA8283@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Sep 2009 19:08:25 -0700
Message-ID: <43e72e890909081908p64d243ffpef1d24281b485602@mail.gmail.com>
Subject: Re: 2.6.27 maintenance plans after 2.6.32 is released
To: Greg KH <greg@kroah.com>
Cc: Chris Wright <chrisw@sous-sol.org>, stable-review@kernel.org,
       linux-kernel@vger.kernel.org, stable-review@linux.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 4:04 PM, Greg KH<greg@kroah.com> wrote:
> On Tue, Sep 08, 2009 at 12:44:23PM -0700, Luis R. Rodriguez wrote:
>> On Tue, Sep 8, 2009 at 12:30 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>> > I was curious if 2.6.27 is planned to be supported after 2.6.32 is
>> > released, or will that be dropped in favor for 2.6.28 as the last
>> > supported kernel. How does dropping an old kernel for stable
>> > maintenance consideration typically work?
>
> .27 is a "long term" support kernel that I've decided to keep going for
> a variety of reasons.  .28 and .29 are currently no longer maintained.

Oh good to know, for some reason I expected we'd support 27..HEAD.

> So .27 is "special" right now, and seems to be working well.  I keep
> revaluating if it's worth keeping going, and so far, it seems like it
> is, if for nothing else, personal reasons as I have a few servers based
> on it :)
>
> For .30, we will probably do a few more releases once .31 is out, and
> then drop it as well.
>
> I'm confused as to what .32 has to do with any of this, that's months
> away...

I meant 31. Thanks for the explanation.

  Luis
