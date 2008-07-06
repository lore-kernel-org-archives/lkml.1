Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbYGFUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbYGFUwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbYGFUwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:52:05 -0400
Received: from mail.lang.hm ([64.81.33.126]:40382 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451AbYGFUwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:52:00 -0400
Date: Sun, 6 Jul 2008 13:52:01 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Woodhouse <dwmw2@infradead.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       jeff@garzik.org, andi@firstfloor.org, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
In-Reply-To: <1215376034.3189.127.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.1.10.0807061351040.11010@asgard.lang.hm>
References: <1215178035.10393.763.camel@pmac.infradead.org>  <486E2818.1060003@garzik.org> <20080704142753.27848ff8@lxorguk.ukuu.org.uk>  <20080704.134329.209642254.davem@davemloft.net>  <20080704220444.011e7e61@lxorguk.ukuu.org.uk> 
 <alpine.DEB.1.10.0807061311030.11010@asgard.lang.hm> <1215376034.3189.127.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008, David Woodhouse wrote:

> On Sun, 2008-07-06 at 13:17 -0700, david@lang.hm wrote:
>> if David W were to make it possible to not use the load_firmware() call to
>> userspace and build the firmware into the driver (be it in a monolithic
>> kernel or the module that contains the driver)
>
> You _can_ build the firmware into the kernel.

right, but not into a module. you have half of the answer in place, but 
not all of it.

David Lang
