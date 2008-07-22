Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYGVIUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYGVIUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYGVIUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:20:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:62898 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYGVIUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gCpG3+QXyvqq4wF2EudWqtnzk+clbT7EdjTNHI8z6qB5Gkkt9fIC3NGfFGvb1cO1Kt
         5bD5SFaIdUC+5F3atvtENH8+u0w6jKoEsIOXsyPljbIzbtXjPs3LPNOmpbz54vi8I+67
         /5gAau6DnSLnneiz52o9HmhdzU+JrodSStV1M=
Message-ID: <488597C0.6000705@gmail.com>
Date: Tue, 22 Jul 2008 10:18:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Daniel Kubiak <sor@czlug.icis.pcz.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux based router Kernel Panic (2.6.23 - 2.6.26-rc9)
References: <48849FA7.9060604@czlug.icis.pcz.pl> <20080721151559.GA12604@martell.zuzino.mipt.ru> <4884E644.9040701@czlug.icis.pcz.pl> <4884E7AC.2050504@gmail.com> <4885773B.5080806@czlug.icis.pcz.pl>
In-Reply-To: <4885773B.5080806@czlug.icis.pcz.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2008 07:59 AM, Daniel Kubiak wrote:
> Jiri Slaby pisze:
>>
>> Could you provide also System.map?
>>
> Yes, of course: http://www.sor.osiris.czest.pl/System.map-2.6.26-rc9-nat2

Well, neither the config nor the System.map are not from the kernel you make a 
snapshot from -- it's a 2.6.25 or earlier kernel and you are referring to 
2.6.26-rc9. System.map is useless anyway, I overlooked module addresses in the 
panic before. Try to reproduce with the config you attached and post snapshot 
from that kernel.
