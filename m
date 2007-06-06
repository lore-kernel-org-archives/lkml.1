Return-Path: <linux-kernel-owner+w=401wt.eu-S935063AbXFFTGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063AbXFFTGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765563AbXFFTGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:06:34 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3428 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765521AbXFFTGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:06:33 -0400
Message-ID: <466705C7.3040303@shadowen.org>
Date: Wed, 06 Jun 2007 20:06:47 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Robert Hancock <hancockr@shaw.ca>, Gabriel C <nix.or.die@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <fa.463099pz3wyAW1RRKsHFuX299RE@ifi.uio.no>	<fa.zIhbKpmFY9tR8ro0OTwpTvD79Xk@ifi.uio.no>	<4666C640.5040408@shaw.ca>	<4666FA92.202@shadowen.org> <20070606112722.544adf13.akpm@linux-foundation.org>
In-Reply-To: <20070606112722.544adf13.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 06 Jun 2007 19:18:58 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> 
>>>> http://frugalware.org/~crazy/other/mm/2.6.22-rc4-mm1/config
>>>>
>>>> Regards,
>>>>
>>>> Gabriel
>>> Presumably because:
>>>
>>> # CONFIG_PCI_GOMMCONFIG is not set
>>>
>>> I'll cook up a patch later today.
>> This one is affecting machines in TKO noce that the e820 problem is fixed.
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/hot-fixes/revert-mmconfig-validate-against-acpi-motherboard-resources.patch
> should fix that.

TKO _should_ pick that up automatically.

Indeed there seem to be some GOOD status' popping out on those machines
now.  They should be up on TKO shortly.

Thanks.

-apw
