Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZFEN1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZFEN1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZFEN1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:27:45 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:62554 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZFEN1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M+7NsbNinUW4ltJpX6IX+P9cAm8mWftXRFjmxhr6meRygxjJkzloBSlJV8Qn/6c+P3
         zqjAesehcZZ6h8XZIJD8OqIc7/KnWDh9/hCWbZJpUMOfHkLjS6PejbcoWMwdWHJ96h8Y
         1Z32EvEJCpt3Cge7WGqdy3IEAmB+QaeAeuI5c=
MIME-Version: 1.0
In-Reply-To: <1244208197.23850.22.camel@localhost.localdomain>
References: <1244168990-28355-4-git-send-email-dbaryshkov@gmail.com>
	 <1244184737.22576.94.camel@johannes.local>
	 <20090605071529.GA7064@doriath.ww600.siemens.net>
	 <20090605.005418.07362083.davem@davemloft.net>
	 <20090605091229.GA25280@doriath.ww600.siemens.net>
	 <20090605094619.GB23085@build.ossfans.org>
	 <bc64b4640906050345t5ed23d7bxc8a777a4a0ada147@mail.gmail.com>
	 <1244208197.23850.22.camel@localhost.localdomain>
Date: Fri, 5 Jun 2009 17:27:43 +0400
Message-ID: <bc64b4640906050627s466b4289h7e67864c0cfbf184@mail.gmail.com>
Subject: Re: [PATCH 3/5] net: add NL802154 interface for configuration of 
	802.15.4 devices
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Sergey Lapin <slapin@ossfans.org>, David Miller <davem@davemloft.net>,
       johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       sfr@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/5 Marcel Holtmann <marcel@holtmann.org>:
> Hi Dmitry,
>
>> > Dmitry, please toss all my @siemens.com addresses from all patches, since my
>> > access is already disabled and it's pointless to have invalid emails
>> > in source tree. Please replace them with @ossfans.org ones.
>>
>> Could you please send an incremental patch on top of this serie? I
>> hope that my last
>> push can be pulled/merged and I don't want to redo all commits.
>
> either start getting used to git-rebase or manual rebase of commits. You
> better be familiar with git before asking people to merge. We are
> expecting you to provide proper trees to pull from a patches to apply.

I am used to git rebase and git merge. I am used to maintaining topic branches
and merging them into development trees. I'd just prefer to have a 'merge-ready'
branch that isn't rebased too much, if things can be done clearly w/o
unnecessary
rebase.

> And since Dave and Johannes already asked you to fix the __KERNEL__ part
> you have to redo the pull request anyway.

It's done long ago.

-- 
With best wishes
Dmitry
