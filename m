Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbYH0Hjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbYH0Hjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYH0HjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:39:09 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:34918 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbYH0HjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:39:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=FMr+CE/BzwBTKZs0nhLm3TSF3liRLHSP7HD5XaV0nHRpVgdzh7IPJAHQ7JjFrm9s;
  h=Received:Cc:Message-Id:From:To:In-Reply-To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:References:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Message-Id: <E38B9DE5-5BE3-4400-B5FC-F75D9A6BBDAA@earthlink.net>
From: Bruce Leonard <brucle@earthlink.net>
To: dedekind@infradead.org
In-Reply-To: <1219814980.18027.123.camel@sauron>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 1/2] Clean up of code found when adding support for > 2GiB MTD devices
Date: Wed, 27 Aug 2008 00:39:04 -0700
References: <48AB3AAC.7030900@earthlink.net> <1219814980.18027.123.camel@sauron>
X-Mailer: Apple Mail (2.926)
X-ELNK-Trace: 481fc18f0ae4055094f5150ab1c16ac08868399773331e30c19f07444c069f3fc99af199f8107469350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 70.110.34.130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

On Aug 26, 2008, at 10:29 PM, Artem Bityutskiy wrote:

> Hi,
>
> On Tue, 2008-08-19 at 14:27 -0700, Bruce Leonard wrote:
>> These are just some code cleanups that I found while working on the  
>> MTD sub-system.
>> From: brucle <brucle@selinc.com>
>> Date: Wed, 13 Aug 2008 17:16:48 -0700
>> Subject: [PATCH] Code clean up preping for support of > 2GiB MTD  
>> devices
>>
>> Signed-off-by: Bruce D. Leonard <brucle@selinc.com>
>
> For this clean-up patch,
>
> Acked-by: Artem Bityutskiy <dedekind@infradead.org>
>
> However, are you shure it is against the mtd-2.6.git tree?

This patch set is against the mainline, 2.6.27-rc3.  At the time I  
posted the patch I was only a day or two out from pulling the latest  
from Linus' tree.  It's now a couple of weeks out of date I think.

Bruce

