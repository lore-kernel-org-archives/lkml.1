Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZJ2Ool@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZJ2Ool (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZJ2Ook
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:44:40 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:33896 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbZJ2Ooj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ovUdx5YgaJcBHNRgNKKx2o5YpYjEDZgiBtqnmxBHajVFkHLGyXvNCVEySxgUzoThjs
         KL+3hmouGmSw8Q7+rKJnPhHWrLR6A/nZFlxCI2VssUlmLoTW45HNjeXsPmkGvoUK+XYL
         R5pBHpTh0I0CEHKls5gHOYVY0neBKblJAGCvY=
MIME-Version: 1.0
In-Reply-To: <200910291539.16476.mb@bu3sch.de>
References: <200910291435.54203.bzolnier@gmail.com>
	 <200910291514.40318.bzolnier@gmail.com>
	 <20091029.072101.109209962.davem@davemloft.net>
	 <200910291539.16476.mb@bu3sch.de>
Date: Thu, 29 Oct 2009 15:44:42 +0100
Message-ID: <14add3d10910290744n3abd1cf8w42a6311108eb2fa7@mail.gmail.com>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: David Miller <davem@davemloft.net>, bzolnier@gmail.com,
       penberg@cs.helsinki.fi, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 3:39 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Thursday 29 October 2009 15:21:01 David Miller wrote:
>> The issue is that John disagrees with you can you can't handle
>> that.
>>
>> So instead of continuing to discuss things with him and the
>> other wireless folks, you want me to just overreach everybody
>> and revert someone else's work.
>
> In the end this results in the driver maintainer being forced to maintain
> code and handle bugreports for code that he disagrees with in the first place.
> This is unacceptable and has to be resolved in some way.
> If it's not possible to get it reverted through John (for whatever reason),
> you're in charge to help the actual code maintainer out.
>
>> I'm not going to do that sorry, learn how to work with the
>> wireless people instead.
>
> This is not the problem.
> The problem is that stuff is merged without ack from the maintainer
> and it's virtually impossible to get the stuff reverted. The only real
> way for the maintainer to resolve this is 1) live with it or 2) fix it.
> And that's bad, because it completely invalidates his priority queue.
>
> Just like you must not bypass John, the driver maintainers must not be bypassed, too.
> The quality control does _only_ work if nobody in the chain is bypassed.
> But in this situation the quality control did already fail and it should be
> tried hard to resolve (=revert) the situation instead of pointing at John.
>

Hold on here. In this case it is the driver maintainer (i.e. Ivo for
the rt2x00 project) that
submitted this driver for inclusion, so the driver maintainer has not
been bypassed in
this case.

Apparently Bart has issues with the code submitted by the maintainers
and has been
unsuccessful in convincing others about these issues.

---
Gertjan.
