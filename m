Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbXFFStF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbXFFStF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbXFFSsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:48:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:28515 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXFFSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=fQFNaum3OkEGJQSEUYooY7WcBXKD5zEk9vvNxUyICAPDcZixhaCxeQgX2geKpvCD433T1VhMuhu3VTKdYY205Q34J8mpnFHrLxEWtYREL9QuPwNKJY6hlorp80igenG0GUkrTxhMN8DiQgNzrHzGk1Si41FZCIVMx2EU33Rxq9E=
Message-ID: <4667018D.7020407@googlemail.com>
Date: Wed, 06 Jun 2007 20:48:45 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton pisze:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> 

Kay, your patch gregkh-driver-block-device.patch breaks Fedora 7 initrd
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/initrd.jpg

Please fix it ASAP, I can't test kernel...

Regards,
Michal

-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"
