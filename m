Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZFAI5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZFAI5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZFAI5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:57:39 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:41305 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZFAI5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H5DsPZjgm6qP5llaS+CP27VXAhSurb0b6tdzHebg51HN4ElK9//gVMTJaPepNC2lNp
         0am0m8Df/H6OINCILjLRpci4qkf5Sss0Twu8yz5gr5LgHUh6SalRYRzWudmHGRpT5RMM
         kzDXAwf2lZzAxf1V1XPCdrc96Ka5dxTA5v7i0=
MIME-Version: 1.0
In-Reply-To: <d82e647a0906010027qe1b3465we5724aa4ed35436@mail.gmail.com>
References: <d364733c0905312349m6b5c8664h6cc7701a576c6b7d@mail.gmail.com>
	 <d82e647a0906010027qe1b3465we5724aa4ed35436@mail.gmail.com>
Date: Mon, 1 Jun 2009 16:57:39 +0800
Message-ID: <d364733c0906010157m416905f6xa166b562b70c9515@mail.gmail.com>
Subject: Re: new implementation of mutex
From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/1 Ming Lei <tom.leiming@gmail.com>:
> 2009/6/1 Ð»¸Ù <xiegang112@gmail.com>:
>> I debug it and find the debug_locks = 0.  Is this why there is no
>> warning message and how turn it on? (I also had CONFIG_LOCKDEP_SUPPORT
>> on.)
>
> Please confirm CONFIG_PROVE_LOCKING is enabled.

It still does not work. No warning is found. It still behaves as
binary semophore.

Thanks,
>
> Thanks,
> --
> Lei Ming
>



-- 
Xie Gang
