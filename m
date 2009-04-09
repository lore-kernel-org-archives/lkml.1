Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbZDINOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbZDINOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbZDINOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:14:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41412 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbZDINOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IhSJlXwUaNrkpao074YEW/XcnSIEUn0JPNGpEw0+RVWOQtfOEbK8dnE8EMuM17rBNv
         pxy0yzbbKqw0yWEEBfA/vxokz5kZ04EjYd9wOsZIt2WBgwKu/0joLX+d82id5uFpVIuO
         t8xL6SZcqszvcbwiO5K/cB9L1xw9cvxoYJIl4=
MIME-Version: 1.0
In-Reply-To: <49DDF2AF.50308@trash.net>
References: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com>
	 <20090409021804.GA1756@gondor.apana.org.au>
	 <20090409023547.GA1878@gondor.apana.org.au>
	 <8db1092f0904090546j54ac6759i9c36f214ce1109bc@mail.gmail.com>
	 <49DDF2AF.50308@trash.net>
Date: Thu, 9 Apr 2009 15:14:31 +0200
Message-ID: <8db1092f0904090614q7d441a72od2c5615876797e43@mail.gmail.com>
Subject: Re: [2.6.30-rc1] device-mapper: table: 254:0: crypt: Error allocating 
	crypto tfm
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-crypto@vger.kernel.org, arjan@linux.intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/9 Patrick McHardy <kaber@trash.net>:
> Maciej Rutecki wrote:
>>
>> 2009/4/9 Herbert Xu <herbert@gondor.apana.org.au>:
>> [...]
>>
>> Yes, patch helps. Thanks
>
> It also seems to fix a netfilter problem with modules not loaded
> automatically anymore.
>

...and mount my usb disk :-)

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
