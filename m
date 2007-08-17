Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbXHQIf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbXHQIf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 04:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXHQIfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 04:35:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:5237 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbXHQIfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 04:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c+zTaybHbqfJOwqnrPYAeD12xN7RY+PS5kZe22YTvrxGK/zLntM4rRsO21UMTpD+Q92B0tP/b7RvP78l/1dwG5kShAR7yoBckq2aovhw1rhqxPfIXfs8oEfEgtq3Tunpv3MUFw8SkwO+joWToZWkwPg0nUMoupP9nOPCLc/3sKA=
Message-ID: <af3ea28a0708170135r23f7f9a1tf028701e26e3db9c@mail.gmail.com>
Date: Fri, 17 Aug 2007 16:35:00 +0800
From: "ye janboe" <janboe.ye@gmail.com>
To: eric.y.miao@gmail.com
Subject: Re: how can I get an account on master.kernel.org machine
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46C3FB01.9090203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <af3ea28a0708151958h4af993e6o1db3b9adddc14294@mail.gmail.com>
	 <20070815201421.ffbd84f3.randy.dunlap@oracle.com>
	 <46C3FB01.9090203@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy, Eric,
Thanks you very much!

There is only diffs in http://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/.
What's these diffs base on, Linus' kernel tree?

2007/8/16, eric miao <eric.y.miao@gmail.com>:
> And if you purpose is only to download that tree, my suggestion is that
> some of the git trees are not public like linux-arm so the owner can do
> whatever he likes in the tree, and don't ever try to have access to it.
>
> for linux-arm, it will be constantly pulled by Linus, unless you really
> want the _most_ up-to-date patches, which you might find them at
>
>   http://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/
>
> that folder will be constantly refreshed by the maintainer.
>
> - eric
>
> Randy Dunlap wrote:
> > On Thu, 16 Aug 2007 10:58:41 +0800 ye janboe wrote:
> >
> >> I want to down linux-arm git repos, but I do not have an account on
> >> master machine.
> >
> > see http://www.kernel.org/faq/#account
> >
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
>
