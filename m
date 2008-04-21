Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYDUS46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYDUS46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYDUS4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:56:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:28724 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYDUS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AGgRzc70K/kiF6ekt6+zD9NXiLMOlpr2GOopc8bZpVLu+FJhn1ApGzdq+qmlJERqUNGe8oW6D+yihTDAdQybBuT3/SBIGrkT36nPxezKRkmbHNiTOexe9ABiZ6DU992fIN5gB6G5R1jUhC2WBCOeIvPmZ3OBvUo3Tf8SYUoeXGU=
Message-ID: <cd73a99e0804211156l9fdfe77y7735bb4ec79a113a@mail.gmail.com>
Date: Mon, 21 Apr 2008 20:56:48 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Nicolas Ferre" <nicolas.ferre@atmel.com>
Subject: Re: AT91: at91sam9263_devices typo
Cc: "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <480C9B40.20109@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <480C9B40.20109@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Nicolas,

> at91sam9263_devices mci typo

> Andrew, should I send it directly to the patch system or will you integrate
> it in your tree ?

I see at91cap9_devices.c has the same typo.

Please correct both and submit a patch to Russell King's patch system.
(Make sure it applies against
ftp://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/arm:devel.diff)


Regards,
  Andrew Victor
