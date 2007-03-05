Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXCEPWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXCEPWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932453AbXCEPWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:22:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:4622 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbXCEPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:22:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FrjghrA3EBLo+sn5rNFDD39iY5XEY3j24ekajQE25u3tdthp5ObzINVrTi2oh1QUhzMKcsliQfnwVNtR1aBKfXwS7HiqPA0OD316fPhpFJGBEIq2MvQDU1bihFPt6HyC8iaAxHNN1eWFw6zo1RQ/Vj12C/PxxVATOW8OvJdnrQI=
Message-ID: <4d8e3fd30703050722g7844a316m78da0522f0cc81b3@mail.gmail.com>
Date: Mon, 5 Mar 2007 16:22:17 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>, "Andrew Morton" <akpm@osdl.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Cc: linux-kernel@vger.kernel.org,
       "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
In-Reply-To: <200703050453.08154.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org>
	 <200703050453.08154.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Monday 05 March 2007, Nicolas Mailhot wrote:
> >This looks like -mm stuff if you want it in 2.6.22
>
> This needs to get to 2.6.21, it really is that big an improvement.

On 3/5/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Monday 05 March 2007, Nicolas Mailhot wrote:
> >This looks like -mm stuff if you want it in 2.6.22
>
> This needs to get to 2.6.21, it really is that big an improvement.

I didn't try the new cpu scheduler but 2.6.21 is in bug fix only mode
so I don't see how this stuff can go in.

Maybe Andrew can comment about having it in -mm?

Ciao,
-- 
Paolo
