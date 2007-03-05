Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXCENYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXCENYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933482AbXCENYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:24:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:1969 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbXCENYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:24:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NQB832jPcDpdvOmeuvH7PRiCKyhYr3L8tou//JqzNQfKLXHoc/ZmaXy9Qk50uvRB1XCeikOgRpwKCKOClhLnDgyg2CL3u90CqbSXdiFEbPOoEFkr8M2MYGk6u+kjQ86qBxwFdbsJeMmBGjjrTLgleWNLjX45Q5D9jy69CwW6oAA=
Message-ID: <8d158e1f0703050524w6e376cd3hffda0b05da9c78af@mail.gmail.com>
Date: Mon, 5 Mar 2007 13:24:16 +0000
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil problems with recent kernels
Cc: "Dale Blount" <linux-kernel@dale.us>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <45EB98E4.9070307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172250027.15179.16.camel@dale.velocity.net>
	 <1172602444.5420.17.camel@dale.velocity.net>
	 <1172698758.30931.18.camel@dale.velocity.net>
	 <45EB98E4.9070307@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Tejun Heo <htejun@gmail.com> wrote:
> Dale Blount wrote:

>
> This will probably included in the next -stable iteration.  Thanks.
>
> --
> tejun


I can confirm that sata_sil is working great under 2.6.21-rc1.
I have an onboard Silicon Image SATA RAID controller and a PCI Add-on
card, also with silicon image chipset.

2x500GB Samsung
1x400GB Samsung

I am getting maximum troughput and no errors of any kind.


Patrick
