Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbXCND1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbXCND1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 23:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbXCND1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 23:27:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:17601 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbXCND1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 23:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=UYzsIosjPZM+inHwQ+bfPWj+iSr9MiA0eeGRw4VMkZsTZYZoF2K2ubJjGO9YXtwQpyjAVayBOAqSU23Ixp99uqcARR6oM5JZ7SEyL8kWfnOf6HDk0Ku6jP4YpWCLyPX/8piunJZCAY94Nkrvz7Euj1ldR+BHUeKFPKJgqnHVrZI=
Message-ID: <45F76B0F.1050702@googlemail.com>
Date: Wed, 14 Mar 2007 04:25:03 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070207)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Kasper Sandberg <lkml@metanurb.dk>, Con Kolivas <kernel@kolivas.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
References: <200703111457.17624.kernel@kolivas.org> <200703122022.43021.kernel@kolivas.org> <1173692319.5835.611.camel@frg-rhel40-em64t-03> <200703122134.13554.kernel@kolivas.org>            <1173717518.26350.6.camel@localhost> <200703140225.l2E2PJ2k007003@turing-police.cc.vt.edu>
In-Reply-To: <200703140225.l2E2PJ2k007003@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 12 Mar 2007 17:38:38 BST, Kasper Sandberg said:
>   
>> with latest xorg, xlib will be using xcb internally,
>>     
>
> Out of curiosity, when is this "latest" Xorg going to escape to distros,
>   

Already is .. Xorg 7.2+ libx11 build with xcb enabled..


> and is it far enough along that beta testers can gather usable numbers?
>
>   

