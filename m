Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbZB0IU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbZB0IU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZB0IUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:20:12 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:46720 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbZB0IUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:20:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=PNGe9bYYMsSIMmr2jbsLzDIdKid8lkJ7DsY+CtCCzYDmcdjz9NpMDGIaaOi8cUwbUZ
         4hg3Wkyo/HrL2vJwKDg0t6eIvtSScnEynixrH7WObZcV+Ma7kwJQbJKV7aNHm2lxOQau
         k4Yn+q9FYjmY3BYWJHqHD8/f8Bb4+F7HpUY60=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 0/10] ide: flags query macros
Date: Fri, 27 Feb 2009 09:21:07 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090225; KDE/4.2.0; i686; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com> <200902262235.58796.bzolnier@gmail.com> <20090227063822.GA26358@gollum.tnic>
In-Reply-To: <20090227063822.GA26358@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902270921.08182.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Borislav Petkov wrote:

[...]

> > BTW you may want to delay this patch after 2.6.30 as things should
> > become much more peaceful then.
> 
> What exactly is the timeframe here? Do you want to have the updated

Timeframe for 2.6.30 [1] or things becoming more peaceful [2]?

[1] We're in -rc6 so it is probably two-three more weeks before -final
    (then we have two weeks of merge window for draining ide tree queue).

[2] I think that it will happen once we finish unification of ATAPI support.

> version for the 2.6.31 merge window?

That would be ideal from my POV.

Thanks,
Bart
