Return-Path: <linux-kernel-owner+w=401wt.eu-S965769AbXJPWF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965769AbXJPWF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935800AbXJPWFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:05:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:18606 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935912AbXJPWFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CD3h8HIEJfvyMcNPqBCFtNmCx6uTyKtbYWxQLsLqnBJzbE/p7cp2R8H/X2PCG8Qr0vGuLDzWx9nx1G9QEXcw2YkkMcn5HQ7WjYCj/sfBDbqEP4J8HJ+t/eUtRM3Rc6nrWmiigLsvu1OfNGT5ty0LmLB0v4e+BuSY6kjQ5Ni3+wY=
Message-ID: <471534CF.6020609@googlemail.com>
Date: Wed, 17 Oct 2007 00:01:51 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
References: <200710141558.27156.vda.linux@googlemail.com> <47125633.3030404@googlemail.com> <200710151225.39624.vda.linux@googlemail.com>
In-Reply-To: <200710151225.39624.vda.linux@googlemail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Sunday 14 October 2007 18:47, Gabriel C wrote:
>>> Compile tested and applies cleanly to 2.6.23.
>>> I don't have this hardware anymore and cannot run test these patches.
>> I can test these patches on an aic7892 controller later on today if you want.
> 
> I'd appreciate that.
> 
> Do you, by any chance, use aic94xx driver too (drivers/scsi/aic94xx/*)?
> After i'm done with aic7xxx, I may attack this one.

Sorry I don't have any box uses this one , but I'll ask some friends maybe someone has :)

> 
>> BTW while you seems to care about this driver could you have a look at :
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=3062 ?!?
> 
> I am a desktop Linux user, so far I don't use suspend at all. Sorry.

Ok , no problem maybe one 'day' the SCSI folks cares ( where the 'day' may be never ),  I dunno :(
  
> --
> vda
> 

Gabriel
