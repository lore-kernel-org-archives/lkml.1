Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYJAWOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYJAWOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 18:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbYJAWO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 18:14:28 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:20834 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbYJAWO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 18:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SmONP+WeVY3f5g6JqmNfs5tHrwEjRZfQUssR5wOO84BlBYU/oPWnMlAiKZjB++5ogv
         75pJ3GBtbQHo5uxXO2pR6lAmOwuU78WbGN7c18OM1kH823XC5Mnvia5ak1xpgbHnmyhd
         BzVwko14VSX/q8ImbFzzoSvcQbExpIrHW+DPI=
Message-ID: <1a26b4920810011514o4d3ecd9egb409871c8ff5a062@mail.gmail.com>
Date: Thu, 2 Oct 2008 00:14:26 +0200
From: "Pazzo Da Legare" <pazzodalegare@gmail.com>
To: "Ondrej Zary" <linux@rainbow-software.org>
Subject: Re: booting uncompressed kernel on x86
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810020004.28045.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a26b4920810011457t4ad93308u2cc0d2781168f332@mail.gmail.com>
	 <200810020004.28045.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ondreh,

Thank you for your answer.

I tried your patch but on my slow i486-like target (on 2.6.25 and
2.6.27-rc6) but it reboots immediatly after few seconds; during this
time I can see some random and colored chars on the screen.

pazzo

2008/10/2 Ondrej Zary <linux@rainbow-software.org>:
> On Wednesday 01 October 2008 23:57:43 Pazzo Da Legare wrote:
>> I would like to boot uncompressed linux kernel on a embedded x86,
>> should I apply a specific patch for this? I'm using grub boot loader
>> which should boot using elf image but I cannot find any clue.
>> Should I switch to another bootloader?
>
> I did something some time ago - but it's only a quick hack to make my really
> slow (386DX/25) machine boot faster - see http://lkml.org/lkml/2005/7/1/206
>
>>
>> TIA
>>
>> pazzodalegare
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> Ondrej Zary
>
