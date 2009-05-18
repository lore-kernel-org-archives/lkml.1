Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZERBv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZERBv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 21:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbZERBvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 21:51:19 -0400
Received: from claw.goop.org ([74.207.240.146]:44016 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZERBvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 21:51:18 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 May 2009 21:51:18 EDT
Message-ID: <4A10BCEC.3090903@goop.org>
Date: Sun, 17 May 2009 18:42:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, gregkh@suse.de, okir@suse.de
Subject: Re: Where do we stand with the Xen patches?
References: <4A0C770E.2030305@goop.org> <20090518103520J.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090518103520J.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> for-ingo/xen/dom0/pci
>> for-ingo/xen/dom0/swiotlb
>>
>>     Updated with Joerg Roedel, FUJITA Tomonori and Matthew Wilcox's
>>     comments,  Acked-by and Reviewed-bys as appropriate.
>>     
>
> The original code added dom0-specific dma mapping stuff in the generic
> place, which is completely wrong. I asked you to move the hacky stuff
> to Xen-specific code and ack'ed the patchset.
>
> But as I said again and again, the dom0 changes to the generic dma
> mapipng code is really ugly and I don't like them at all. I didn't
> ack'ed such changes.
>   

I didn't mean to imply that you all acked all the patches.  I tried to 
be careful to add Acked tags to the actual patches you each respectively 
acked.

    J

