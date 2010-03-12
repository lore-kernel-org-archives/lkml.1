Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0CLABt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:01:49 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50684 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0CLABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:01:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eAOAOro1ZaOwB9g9wBlHvVZwM/ya7986cE8Ku/rVYvBbnorEhpHoELN+TImxVfa2Uo
         pj18q/n5/nLiyxquh79vKHpoS9DUdotgUgneVz0TRmzi+58O2sBDqcKKRu6Ys8H9kpPP
         +9xHZkntP2pT9iqb4NoFzIpWXjSEgi2qNqhHw=
Message-ID: <4B998465.2080009@gmail.com>
Date: Fri, 12 Mar 2010 00:01:41 +0000
From: Andrew Benton <b3nton@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.3a2pre) Gecko/20100212 Shredder/3.2a1pre
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata2: lost interrupt with kernel 2.6.34-rc1
References: <4B992110.2090300@gmail.com> <4B997FB1.3000404@garzik.org>
In-Reply-To: <4B997FB1.3000404@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/10 23:41, Jeff Garzik wrote:
> On 03/11/2010 11:57 AM, Andrew Benton wrote:
>> Hello,
>> I'm not subscribed to this list, sorry if it's the wrong place to send
>> this.
>> I've been having problems with 2.6.34-rc1, when the system tries to
>> access a
>> lot of files (eg, if I recompile the kernel) it freezes for about 10
>> seconds
>> or so and then I get a message like this in the sys.log:
>
> Does 2.6.33 also have this behavior?
>

No, 2.6.33 works fine. This freezing, waiting for the disk to be reset is
new behavior in 2.6.34-rc1

Andy
