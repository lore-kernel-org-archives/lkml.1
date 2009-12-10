Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbZLJRkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbZLJRkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZLJRkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:40:51 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45330 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbZLJRkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:40:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tXZQOIu3yD/ebftJlqxKCaU5fs/9uriONZRyfb/tdrtLiNiUQHQT2knym6siXOccao
         nOH+fj8CFo8ReH8m+DeA+emBI/DRqMqZhIc2XrL9DprUx9zXDLnvxg9la6I8uV7/u2hu
         //f6uh/GbsFcX/CvSJW/cdC3pJ2Feli9HV+eI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	 <1260459601.18520.26.camel@skunk>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
Date: Thu, 10 Dec 2009 18:40:56 +0100
Message-ID: <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
Subject: Re: [git pull] drm
From: Maarten Maathuis <madman2003@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 5:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 10 Dec 2009, Xavier Bestel wrote:
>>
>> Last time they were asked that, they wanted to be free of changing their
>> kernel/userspace interface before upstreaming.
>
> I've heard all the excuses. If it isn't ready, they shouldn't ship it to
> millions of people. And if it's ready, they should work on merging it.

You assume that Red Hat has full control over the project, which i
don't think is the case. The reason it isn't in staging yet (as far as
i know) is because of some questions over the copyright of some
(essential) microcode. Either the question needs to be answered, or it
has to be reverse engineered to the point that it's possible to
generate it.

>
> No excuses.
>
>                        Linus
>
> ------------------------------------------------------------------------------
> Return on Information:
> Google Enterprise Search pays you back
> Get the facts.
> http://p.sf.net/sfu/google-dev2dev
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
