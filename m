Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbXFFND6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbXFFND6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbXFFNDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:03:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:57994 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443AbXFFNDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Yyw+yks+GDouT7HYf+v/KjL6x9Dh0897e84E8uT2975CF137n8bejThrmmdQhqSAGA7JnTKMHVHKle1IzMPKecmtGknEdc2ULNRfTUwWS+TuPwfcBjyoCaqmvzr21oDrVCna1gO1THzzKdy1Lo69zd7r3So/yD9ApkgJmJTFeVE=
Message-ID: <4666B0C0.5070205@gmail.com>
Date: Wed, 06 Jun 2007 15:04:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/

It freezes during bootup while searching for sata drives on sata_promise. There
were 2 issues with sata_promise in -rc4 IIRC, one was fixed, the latter remains
unresolved. Or, should be this solved too, Mikael, Tejun and is this yet
eanother problem? (In this case I'll post dmesg and co.)

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
