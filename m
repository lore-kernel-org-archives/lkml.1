Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbXFTFW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbXFTFW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 01:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbXFTFWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 01:22:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:6838 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbXFTFWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 01:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QALkpj2iLE77vFywYSVx1VsVaomzxt+LA5PoAVUP4zpxmLRZ1gpl/+OxbKcQW2qU2iOI1AOLjAn2oNY1Wv2xVa2UPSwnG+C80nE9+qBJOZr0JG3BGWwZ41qIKCEUXYfeCWx9FtJsvkGcI660FSvi4w5I7Qd5cvc/H5yfzht/pdQ=
Message-ID: <a8e1da0706192222h1a47a103y38ea2b41b83ceb35@mail.gmail.com>
Date: Wed, 20 Jun 2007 05:22:49 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Li Yang-r58472" <LeoLi@freescale.com>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Cc: "WANG Cong" <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, "TripleX Chung" <xxx.phy@gmail.com>,
       "Maggie Chen" <chenqi@beyondsoft.com>, "Tejun Heo" <htejun@gmail.com>,
       "Fengguang Wu" <fengguang.wu@gmail.com>,
       "Chen Li-jun" <cljun@xiyou.edu.cn>
In-Reply-To: <989B956029373F45A0B8AF0297081890D82DF1@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0706191858w73a453dfjf28895150af85cfe@mail.gmail.com>
	 <989B956029373F45A0B8AF0297081890D82DF1@zch01exm26.fsl.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
2007/6/20, Li Yang-r58472 <LeoLi@freescale.com>:
> > -----Original Message-----
> > From: dave young [mailto:hidave.darkstar@gmail.com]
> > Sent: Wednesday, June 20, 2007 9:58 AM
> > To: WANG Cong
> > Cc: Li Yang-r58472; linux-kernel@vger.kernel.org; gregkh@suse.de;
> TripleX Chung;
> > Maggie Chen; Tejun Heo; Fengguang Wu; Chen Li-jun
> > Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
> >
> > Hi,
> > IMHO, it is not very suitable  for translations  merging into kernel.
> >
> > first, It's impossible to be 100% accurate.
>
> It can be accurate by meaning.  And it can be improved.
>
> > second, two or more language need to be synced with english one, it's
> > a problem in  the long run.
>
> This can be done through good maintenance.  I don't think it's harder
> than maintaining the code in kernel source tree.

Yes, but  the documents updating are always  late than the sources.

In my personal opinion, Of course chinese translaton is a valuable
work, But I don't like huge kernel source with tuns of translations,
english only is always better choice.

Anyway thanks for the work :)

Regards
dave
