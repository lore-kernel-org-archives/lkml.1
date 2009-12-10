Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbZLJTNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbZLJTNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbZLJTNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:13:39 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43994 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761060AbZLJTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:13:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Xu/FP/BvzOHuqSXo0N/tsdOBTEO3M7Jy2hOUjyffMCT7QgZ3HMHtj7sCbeDktuRwuv
         o5paIxTFRwAUNQOo60UbkzAhDXEg1R5e8S65wWoV1rd7TYfhIGuY3rpvpCEmxia5rLOq
         4VitlEqXqG34nMWqbU1MEJUgakJOmMLmQEYRQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	 <1260459601.18520.26.camel@skunk>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
Date: Thu, 10 Dec 2009 21:13:44 +0200
X-Google-Sender-Auth: 97af49759f676e99
Message-ID: <84144f020912101113o6d5e5238o2ab776c427c83295@mail.gmail.com>
Subject: Re: [git pull] drm
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, 10 Dec 2009, Maarten Maathuis wrote:
>> You assume that Red Hat has full control over the project, which i
>> don't think is the case. The reason it isn't in staging yet (as far as
>> i know) is because of some questions over the copyright of some
>> (essential) microcode. Either the question needs to be answered, or it
>> has to be reverse engineered to the point that it's possible to
>> generate it.

On Thu, Dec 10, 2009 at 8:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I think people are just making up excuses, as evidenced by the fact that
> you're quoting a different excuse than I've heard before.

AFAICT, the "problem" here is that the guys running the nouveau
project are simply not interested in merging the damn thing. I guess
at some point one of us just needs to grab the code and send it to
Greg for inclusion in -staging?

                        Pekka
