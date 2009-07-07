Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbZGGVNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbZGGVNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZGGVN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:13:26 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45387 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZGGVNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xr0q3goSqKn1ZXoQXopwnbg2O52hUwJiSviKFB39DWFndoOxj153DKz+GRJrn9faB2
         +1Ksm/rJe5fYrkfDGFvPrcMVBxGxDt49tmGFV31IzxQYctvfjKGFgOeftntIY//S2ic1
         bd6JcxFteFmLoUhZ/Zw/tIcucDW8AV7Jygr7c=
MIME-Version: 1.0
In-Reply-To: <200907070040.14796.rjw@sisk.pl>
References: <4A438BA7.9010800@tuffmail.co.uk>
	 <8db1092f0906251016l5ac85bfdpbac841b939cfac2a@mail.gmail.com>
	 <4A43B1FC.7060609@tuffmail.co.uk> <200907070040.14796.rjw@sisk.pl>
Date: Tue, 7 Jul 2009 23:13:22 +0200
Message-ID: <8db1092f0907071413s564571f2jc7a5922211535079@mail.gmail.com>
Subject: Re: 2.6.30-rc1: touchpad disabled on hibernation
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/7 Rafael J. Wysocki <rjw@sisk.pl>:

> Alan, Maciej, can you both try the patch at
> http://patchwork.kernel.org/patch/34075/, please?
>

Sorry for delay.

Patch solves problem. Thanks.


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
