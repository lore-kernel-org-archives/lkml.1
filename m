Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZI2J3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZI2J3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZI2J3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:29:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:30359 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZI2J3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FwEHEunh/lrZuvuO/5ZFey6LBKFixTRurOlDqRlNQA9Lix2DhLcxbYo57l1LOKUBN4
         6EvqcpquAgUd3/njbWDTpkuQKpxgJ5cYlHHmtOEuun4JOnQQrgthGPljTKmBb2XeB8gA
         ekkpgtpuoqyXVvyldgQNR8EpNdN068ZOo3Tuo=
MIME-Version: 1.0
In-Reply-To: <4AC1D0F5.4050709@gmail.com>
References: <38b2ab8a0909290109m3f82c161j4fb0f1266152877e@mail.gmail.com>
	 <4AC1D0F5.4050709@gmail.com>
Date: Tue, 29 Sep 2009 11:29:48 +0200
Message-ID: <38b2ab8a0909290229l2b9a459eydde0742cdb60c2ec@mail.gmail.com>
Subject: Re: WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct
From: Francis Moreau <francis.moro@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 11:18 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Francis Moreau a écrit :
>>
>> It happens on 2.6.31 and older kernels as well though I don't remember
>> when it really started.
>
> Could you please try following patch ?

I'll report back the result at the end of the day (ie in 8 hours).

Thanks
-- 
Francis
