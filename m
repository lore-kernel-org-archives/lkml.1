Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYHTU2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYHTU2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYHTU2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:28:00 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48820 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYHTU16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cs5WWQRy3qFH77om2X7GxhKIj/42g642y7EQAE7xFNRGP0ImQUyaSFF3mYyWAAJO44
         SJVagIFptJwnkbK0IIbVjgildznS0LDXld7d1dRWy4tKw3eXdOlBplj4AZ/MzNfq10dy
         5w2rFmggBgX9+X2F4BZdzpbguEuIZDiKjCDW0=
Message-ID: <b170af450808201327q48b5b2e0n319c89b0fc1759b6@mail.gmail.com>
Date: Wed, 20 Aug 2008 22:27:57 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging request"
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <48AC3FA4.9080603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	 <sNRO-BDDjQL.A.DYF.sazpIB@albercik>
	 <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com>
	 <48AB5D17.5030600@goop.org>
	 <b170af450808200410v3d7cd076h3e62546b48ddf507@mail.gmail.com>
	 <48AC3FA4.9080603@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7KKSLdq016659

2008/8/20 Jeremy Fitzhardinge <jeremy@goop.org>:> RafaÅ‚ MiÅ‚ecki wrote:>> Sure, as everything to help debugging this :)>> http://bugzilla.kernel.org/attachment.cgi?id=17330>>>> Thanks, but could you post the *full* dmesg output, including the added> lines?  I want to see the other things it prints around there.I added full dmesg 5 minutes after adding grepped:http://bugzilla.kernel.org/attachment.cgi?id=17331
> That said, I don't see anything unexpected in here.  It would be> interested to compare to the E820 map.OK, I'll compare that tomorrow.
> Also, what kind of machine is this?  Oh, Vaio. Hm.  Have you checked to> see whether there's an updated BIOS?  How much memory does it have> installed?It's Sony Vaio FW11 with 4GB of RAM. Will chec for BIOS update tomorrow.

-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
