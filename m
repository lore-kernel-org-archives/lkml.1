Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbXG3Oxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbXG3Oxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbXG3Oxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:53:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:20864 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbXG3Oxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X1WichmMXy6iZek2m4Bpbs0qtLGC0SuJvF84dCkF72vmf+V1qSufkXm0L7YNmwVMmTVAHQZ/XT688X3nnL0CwfGliVuaLIZgO8WSIgpNqyYPzpSc5C7CG4dKE3xdyZLh9U7HRhdPZj0HMj62KCruxByCsr0X7ftyJv1OYxjw+7M=
Message-ID: <e1d5030b0707300753m400e5196w99a4c05430c36572@mail.gmail.com>
Date: Mon, 30 Jul 2007 20:23:42 +0530
From: "Midhun A" <midhunagni@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Testing of CPRM on SD Card
Cc: "Sriram, Kannan" <ksriram@ti.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-mtd@lists.infradead.org
In-Reply-To: <20070730135723.4e5338b4@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e1d5030b0707280108v236cc522m454c58e1044f1996@mail.gmail.com>
	 <0A50DBE80DD6674E94F7269DC964A7B6440EDA@dbde01.ent.ti.com>
	 <20070730135723.4e5338b4@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey All,

    Thanks a lot for the replies. I have the development keys. But the
algorithm and some intellectual property needs to be licenced from the
4C entity guys to implement it. As of now I just want to test the CPRM
functionality. So licensing the algo for a prototype testing is a huge
cost.

   That is why I was looking for an already implemented solution -
hardware/software - so that I can just test. If it does not suite our
needs, then I have just paid for a chip only and not for a whole
license.

  Seems like there is no other way out than shelling out money for the
license. :(

Thanks anyways,
Midhun.



On 7/30/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 30 Jul 2007 11:20:58 +0530
> "Sriram, Kannan" <ksriram@ti.com> wrote:
>
> >
> > Midhun,
> >
> >  There is no open-source implementation of CPRM (SD-Audio/ SD-Bind
> > standards). So first of all, you need to license keys from 4C (device
> > keys, media keys etc) and do your own implementation.
>
> Also remember that if you do your own implementation in the kernel you
> will be required to publish the source code under the GPL and that will
> not be permitted with the CPRM licensing. Thus you will need to do all
> the work in user space.
>
>
