Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbZDINXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbZDINXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbZDINWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:22:54 -0400
Received: from stinky.trash.net ([213.144.137.162]:52522 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZDINWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:22:53 -0400
Message-ID: <49DDF6A3.5080304@trash.net>
Date: Thu, 09 Apr 2009 15:22:43 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-crypto@vger.kernel.org, arjan@linux.intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [2.6.30-rc1] device-mapper: table: 254:0: crypt: Error	allocating
 crypto tfm
References: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com> <20090409021804.GA1756@gondor.apana.org.au> <20090409023547.GA1878@gondor.apana.org.au> <8db1092f0904090546j54ac6759i9c36f214ce1109bc@mail.gmail.com> <49DDF2AF.50308@trash.net> <20090409131805.GA2059@gondor.apana.org.au>
In-Reply-To: <20090409131805.GA2059@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Thu, Apr 09, 2009 at 03:05:51PM +0200, Patrick McHardy wrote:
>> It also seems to fix a netfilter problem with modules not loaded
>> automatically anymore.
> 
> They should still autoload, but now you need to retry the operation
> manually :)

Right, the second attempt succeeded :)
