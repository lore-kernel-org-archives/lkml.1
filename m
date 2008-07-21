Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbYGUTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbYGUTtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYGUTtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:49:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:9986 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYGUTtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x39KePkI2DXX4OaSZ+ZwTEgpIvvAuZI0gqRDh6ZPybZa7ULy5h+33TWU2mtPHIvioY
         z304FTMV5UxmOlrSkftTP9inQXPKKZQ2Bt2lkfPZXmEBdJhPr2PW3W5q6txiRsiS31Qv
         +WMS8KyaPCBzDk4ZFszVy9Bf1ajoxCCVwiZAU=
Message-ID: <4884E7AC.2050504@gmail.com>
Date: Mon, 21 Jul 2008 21:46:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Daniel Kubiak <sor@czlug.icis.pcz.pl>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux based router Kernel Panic (2.6.23 - 2.6.26-rc9)
References: <48849FA7.9060604@czlug.icis.pcz.pl> <20080721151559.GA12604@martell.zuzino.mipt.ru> <4884E644.9040701@czlug.icis.pcz.pl>
In-Reply-To: <4884E644.9040701@czlug.icis.pcz.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2008 09:40 PM, Daniel Kubiak wrote:
> Alexey Dobriyan pisze:
>> Enable CONFIG_KALLSYMS and CONFIG_DEBUG_BUGVERBOSE next time.
>>
>> Or you can grab vmlinux of that kernel and decipher addresses by hand.
>>
> I've got CONFIG_KALLSYMS and CONFIG_DEBUG_BUGVERBOSE set to yes, here is 
> my kernel config http://www.sor.osiris.czest.pl/config-2.6.26-rc9-nat2

Could you provide also System.map?
