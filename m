Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYJ3JVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYJ3JVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYJ3JV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:21:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:14289 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYJ3JV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:21:28 -0400
Message-ID: <ac3eb2510810300221l2d08609bsace8368aa5578641@mail.gmail.com>
Date: Thu, 30 Oct 2008 10:21:26 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: mmc: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <20081030100652.73730cdf@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225329600.5970.72.camel@nga.site>
	 <20081030100652.73730cdf@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:06, Pierre Ossman <drzeus@drzeus.cx> wrote:
> On Thu, 30 Oct 2008 02:20:00 +0100
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: mmc: struct device - replace bus_id with dev_name(), dev_set_name()
>>
>> Cc: Pierre Ossman <drzeus@drzeus.cx>
>> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
>> ---
>
> That patch looks good to me. Are the prerequisites already in Linus'
> tree so you want me to push this to him as well?

Yes, it's all in Linus' tree and also released in .27. Please push it.

Thanks,
Kay
