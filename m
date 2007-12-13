Return-Path: <linux-kernel-owner+w=401wt.eu-S933857AbXLMWIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbXLMWIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXLMWIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:08:40 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:2400 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763AbXLMWIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=w6B3m50adwbfS3d3m8wvodbvWT9ODQCngPNGx05YZryWnZ6WrMhHauZbB4zMgCvkjoTEy9ct14+RjW8FfOKN0NJMAJcdyoFcgZD59tOepkueWHPMEcxwTxcGKSICjrF5huiiNZx9nTh8dyHBqfdFPjnvUkPWtXBRbc5LyqPyLXg=
Message-ID: <4761AD0A.5010700@gmail.com>
Date: Thu, 13 Dec 2007 23:07:06 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Kosin <jkosin@intcomgrp.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFT] Port 0x80 I/O speed
References: <9zmRR-3pA-25@gated-at.bofh.it> <47615D81.30707@intcomgrp.com>
In-Reply-To: <47615D81.30707@intcomgrp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-07 17:27, James Kosin wrote:

> model name      : Pentium III (Katmai)
> cpu MHz         : 499.156

> [root@beta jkosin]# ./a.out
> cycles: out 683, in 299

Thanks much, you made spot 32 ;-)

http://lkml.org/lkml/2007/12/12/309

By the way, if anyone in this/these thread(s) wrote something today (*) they 
would like me to reply to -- my horseshit ISP is completely crapping out on 
me and I haven't seen your message. Resends ofcourse welcome.

(*) [now - 16 hours, now]

Rene.
