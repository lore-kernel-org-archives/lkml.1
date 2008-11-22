Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYKVIKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYKVIKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 03:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYKVIKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 03:10:06 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:18035 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYKVIKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 03:10:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=S5yM+NjiiSb0JNu57JUSF5Rno1Mi/LYbgCJRhCpPlSINzR42g6+Ev0inFyi0Vb0e9V
         4Mx3tWD+lCdZLq3tDh5Wd1BqEZoEfNzNwkgqAouZ4jdCqCVERKSMvq4MEXMzuFVe7CA6
         K62XI5RO2ybwxhQkO9J18UAffFvcg5t3ebmk0=
Message-ID: <9929d2390811220010q5a064ccblc182ce0128250da6@mail.gmail.com>
Date: Sat, 22 Nov 2008 00:10:03 -0800
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] driver/net/*: remove redundant argument comments
Cc: qhfeng.kernel@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081121.235656.193713995.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4927b790.0e0d6e0a.65cc.ffffcb05@mx.google.com>
	 <9929d2390811212355j635e0e8iee0e53678efc5f09@mail.gmail.com>
	 <20081121.235656.193713995.davem@davemloft.net>
X-Google-Sender-Auth: e0c259e1aacfc341
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 11:56 PM, David Miller <davem@davemloft.net> wrote:
> From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
> Date: Fri, 21 Nov 2008 23:55:27 -0800
>
>> I would agree that "@rx_ring: pointer to receive ring structure" is
>> probably not the best documentation, but rather than removing it, I
>> would suggest improving it.
>
> Jeff, he's removing it because the function no longer takes
> that argument any more.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I apologize, based on the patch comment of "remove redundant argument
comments" I took that he was removing comments that were "unnecessary
and repetitive" and not referring to "non-existent arguments".

I rescind my Nak.

-- 
Cheers,
Jeff
