Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZKPOBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZKPOBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZKPOBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:01:02 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60820 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZKPOBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=W1Z3USkzsDU0gdAVFwIYS4/Dp1qNX0wLP5gJLM8Riyout/Q/aVPidiD8X3b6R8w/8Q
         UWD9dXYfQcaZkNA02grw1xp+KTNFDCzxPexpzUBuyc4VuwO9MIdXPb7IUmDnm71XvktP
         ytXuECyDmFEq0nBynnYjv9ywJPwZst5ITdsDI=
Message-ID: <4B015B1F.3000604@gmail.com>
Date: Mon, 16 Nov 2009 09:01:03 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 resent] net: TCP_MSS_DEFAULT, TCP_MSS_DESIRED
References: <4B00A858.8000705@gmail.com> <20091115.205442.77893528.davem@davemloft.net>
In-Reply-To: <20091115.205442.77893528.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I already applied this patch to net-next-2.6, there is no need
> to resend it.
> 
Cool, there wasn't your usual "applied" response to the list, so the
instructions say send again after waiting (5 days in this case), as it
might have been overlooked.

'git fetch' followed by 'git rebase origin/master' re-applies my patches
locally, but doesn't inform me that this patch has already been applied,
it just handles it silently....

I've found the log, it's commit bee7ca9ec03a26676ea2b1c28dc4039348eff3e1

Thanks!
