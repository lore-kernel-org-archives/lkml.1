Return-Path: <linux-kernel-owner+w=401wt.eu-S941520AbXHJQSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941520AbXHJQSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941441AbXHJQRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:17:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:7829 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S941393AbXHJQRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=W2nH8ro/p8NSydla5ChhIvvsoCCLvLvAjP/QEaVYRxJsuGtoE7gIijWnn5kzqyFpNvuS+CuCmMfAre6fiE8FQizfC65AIgjX35c2GTE/XyHSjSl6lloh8Cqk8ebAafkvMYv5jjxGLA0lsDuFdWqJDvLFbgrugQK6trShIWkT9uU=
Message-ID: <46BC8F71.3070006@googlemail.com>
Date: Fri, 10 Aug 2007 18:16:49 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Netdev <netdev@vger.kernel.org>, coreteam@netfilter.org
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org>
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton pisze:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/
> 

Yet another sysctl table check failed

[   88.949055] Netfilter messages via NETLINK v0.30.
[   89.485399] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   89.491892] sysctl table check failed: /net/netfilter/nf_conntrack_generic_timeout .3.19.13 Missing strategy
[   89.558178] xt_state: Unknown symbol nf_conntrack_untracked
[   89.563942] xt_state: Unknown symbol nf_ct_l3proto_module_put
[   89.569870] xt_state: Unknown symbol nf_ct_l3proto_try_module_get
[   90.852319] NET: Registered protocol family 17

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
