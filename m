Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYLVVjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYLVVjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYLVVjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:39:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:47145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYLVVjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:39:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jxrBNHG/06G54UgdQCpuWKT/yW/2FfIKtGXIc3HV8rNAaG6zp/x1wFD0buHMzRIW3J
         XyZpQjbRaMF9Ju16n1aCzmp8bKWEK227PdZVxGKCwoZZRnk1ASQkLIVlDIsTSK2fh9ao
         pVNAlZODYTgwElLoO0VLwZhNh6mRukgqvCVRw=
Message-ID: <49500906.70309@gmail.com>
Date: Mon, 22 Dec 2008 22:39:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Soeren Sonnenburg <kernel@nn7.de>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: ath5k_pci: gain calibration timeout / unable to reset hardware
 -11
References: <1229923913.3886.7.camel@localhost> <20081222125819.7353d172.akpm@linux-foundation.org> <4950087E.3080505@gmail.com>
In-Reply-To: <4950087E.3080505@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2008 10:37 PM, Jiri Slaby wrote:
> On 12/22/2008 09:58 PM, Andrew Morton wrote:
>> (cc linux-wireless)
>>
>> On Mon, 22 Dec 2008 06:31:53 +0100
>> Soeren Sonnenburg <kernel@nn7.de> wrote:
>>
>>> Hi,
>>>
>>> I was using the ath5k_pci driver on a macbook pro 1,1 and it is working
>>> for some time but then suddenly messages like the ones below appear and
>>> I have to *turn off* the machine to get it back working (even booting to
>>> osx is not sufficient - osx won't have network when things go wrong as
>>> they do after a couple of hours). Note that this happens with both
>>> 2.6.27 and .28.
> 
> Does the _HW lockup_ happen even with 2.6.28? The lockup should be gone there
> (with the messages still present).

I see Bob already replied, ignore me, he knows better.
