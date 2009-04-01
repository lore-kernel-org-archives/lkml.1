Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbZDAHdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbZDAHdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 03:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbZDAHdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 03:33:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:54504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758399AbZDAHdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 03:33:25 -0400
Message-ID: <49D318B3.1070003@kernel.org>
Date: Wed, 01 Apr 2009 16:33:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove duplicated code with pcpu_need_numa()
References: <20090331.223128.143365884.davem@davemloft.net> <86802c440903312256r6ddbaa22o5c23cf85d83a6662@mail.gmail.com> <49D30469.8020006@kernel.org> <49D31770.9090502@kernel.org>
In-Reply-To: <49D31770.9090502@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 07:33:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Impact: clean up
> 
> those code pcpu_need_numa(), should be removed.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.  Heh... that was a mess.

-- 
tejun
