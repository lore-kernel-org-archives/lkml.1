Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbXFIJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbXFIJXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 05:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbXFIJXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 05:23:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:35006 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbXFIJXO (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 05:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hgXBZk6S2yc9sP2iG7HslJ3sRY/2y+nzrS6DzxhwnWMjK56uvnGqD25r2DQsil5zz3+2Hhr/JvQzdnSpujIj1XowJuylwEIYA66ubn0raGBWggY6FB51MBlAo5fCLDcxlsngxDirsOqSeZapCbO+uIy/bYJByty/toaxhdh27tw=
Message-ID: <466A717F.7030504@gmail.com>
Date: Sat, 09 Jun 2007 11:23:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
CC: CIJOML <cijoml@volny.cz>, Linux-kernel@vger.kernel.org
Subject: Re: BUG: soft lockup detected on CPU#0! 2.6.21.3
References: <200706091029.37296.cijoml@volny.cz> <466A70CE.6070409@gmail.com>
In-Reply-To: <466A70CE.6070409@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> CIJOML napsal(a):
>> Hi all,
>>
>> please take care about following bug commited at bugzilla:
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=8603
>>
>> Thanks a lot!
> 
> Does this happen without atheros drivers? Do you use hal or openhal?

HAL, ok, try to reproduce with untainted kernel. If it no more happens, complain
at atheros.com.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
