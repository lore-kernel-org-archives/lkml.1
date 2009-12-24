Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbZLXQQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbZLXQQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 11:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZLXQQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 11:16:06 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:64586 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbZLXQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 11:16:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=audvLlNSJKO7D4T/SJd4rweIbIhse5793mIkUdjf/HsQsa3YIC01lWIVX4utxaGiN/
         +zDOQlQr8K6KcjUWt8VxeknjunbKlsye9SL5+KD01RAZtzScNq1S7P271C9pH4owKWOF
         lEHq8oE5UkFfA5IdjlR2guUg5hBpIu/a/Mve4=
Message-ID: <4B3393C3.7050408@gmail.com>
Date: Thu, 24 Dec 2009 09:16:03 -0700
From: Berck Nash <flyboy@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Michael Breuer <mbreuer@majjas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: sky2 panic in 2.6.32.1 under load
References: <4B300A2A.8040305@gmail.com> <20091223225855.4a7d00af.akpm@linux-foundation.org> <4B339290.60909@majjas.com>
In-Reply-To: <4B339290.60909@majjas.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Breuer wrote:
>>> Since 2.6.32, I've been getting kernel panics under heavy network load
>>> (bittorrent usage).
>>>      
>> Let's cc the right list and developer.
>>
>> This is a 2.6.31->2.6.32 regression?
>>    
> I don't think so. I saw this on 2.6.31 - first kernel I put on this
> system. At the time, I was having issues with intel_iommu and thought
> that the culprit.
> The initial reply to this thread from Daniel Hazelton stated that this
> has been happening since 2.6.25.

Your oops appears to be different than mine.  Hazelton did not provide
any logs, and he said "a version of this" so I don't know if his is the
same or not.
