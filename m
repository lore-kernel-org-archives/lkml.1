Return-Path: <linux-kernel-owner+w=401wt.eu-S965137AbXGSRA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137AbXGSRA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934634AbXGSRAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:00:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:63430 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765811AbXGSRAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xo7KbP8nTSixUy/5WN7p97TOXGtitlng3KVvllAKnHWOx5GK6uobj1e8SnWU2pkAnjlvjcY4sGXINjam1tSbSTf7mq7D3ON8md3IpnzYev44JhgVP4FaoYPRwN2rXLhdjlmSFVtpXCYze1Lw7XF6WkHe08bkAIz96qtF9XC5kbw=
Message-ID: <6bffcb0e0707191000m783db377r84a6c1eb42071793@mail.gmail.com>
Date: Thu, 19 Jul 2007 19:00:07 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [1/2] 2.6.22-git: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" 
	<ukleinek@informatik.uni-freiburg.de>
In-Reply-To: <469F9603.8050603@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <469F92A1.5070203@googlemail.com> <469F9603.8050603@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/07, Avi Kivity <avi@qumranet.com> wrote:
> Michal Piotrowski wrote:
> >
> > Unclassified
> >
> > Subject         : a52b1752c07 broke !SMP: error: implicit declaration of function `WARN_ON'
> > References      : http://lkml.org/lkml/2007/7/17/600
> > Last known good : ?
> > Submitter       : Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
> > Caused-By       : Avi Kivity <avi@qumranet.com>
> >                   commit a52b1752c077cb919b71167c54968a0b91673281
> > Handled-By      : ?
> > Status          : unknown
> >
>
> This has been fixed by Al Viro,
> 8dfd588c3180b7403c402b4545164ee4543f8f86, in mainline.

Thanks!

>
> I am now working on kvm and slub intensely disliking each other.
>
> Note: the wiki page is immutable,

Yes, you need to create an account.

> so I could not update it.
>
> --
> error compiling committee.c: too many arguments to function
>
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
