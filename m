Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbXFZEQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbXFZEQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXFZEQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:16:42 -0400
Received: from [212.12.190.71] ([212.12.190.71]:32993 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750832AbXFZEQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:16:41 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Tue, 26 Jun 2007 07:17:19 +0300
User-Agent: KMail/1.5
References: <200706172319.22381.a1426z@gawab.com>
In-Reply-To: <200706172319.22381.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706260717.19677.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Oliva wrote:
> Consider this scenario: vendor tivoizes Linux in the device, and
> includes the corresponding sources only in a partition that is
> theoretically accessible using the shipped kernel, but that nothing in
> the software available in the machine will let you get to.  Further,
> sources (like everything else on disk) are encrypted, and you can only
> decrypt it with hardware crypto that is disabled if the boot loader
> doesn't find a correct signature for the boot partition, or maybe the
> signature is irrelevant, given that everything on disk is encrypted in
> such a way that, if you don't have the keys, you can't update the
> kernel properly anyway.  The vendor refuses to give customers other
> copies of the sources.  To add insult to the injury, the vendor
> configures the computer to set up the encrypted disk partition
> containing the sources as a swap device, such that the shared-secret
> key used to access that entire filesystem is overwritten upon the
> first boot, rendering the entire previous contents of the partition
> holding the source code into an incomprehensible stream of bits.
>
> Does anyone think this is permitted by the letter of GPLv2?

Yes.

> Is it in the spirit of GPLv2?

No, but that's besides the point.

You can only hold people responsible for the letter, lest there be chaos.

If there is a specific usage spirit you want to protect, then you must 
formulate it in letter.

> How are the sources passed on in this way going to benefit the user or the
> community?

They still have to provide the source by other GPL means of their choosing.

> Is this still desirable by the Linux developers?

Looks undesirable to me, but still valid.


Thanks!

--
Al

