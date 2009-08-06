Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZHFQQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZHFQQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZHFQQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:16:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:40659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbZHFQQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:16:08 -0400
Message-ID: <4A7B01B8.8000902@kernel.org>
Date: Fri, 07 Aug 2009 01:15:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/2 2.6.31-rc5 REPOST] percpu, sparc64: fix sparse	possible
 cpu map handling
References: <4A7AA368.8080606@kernel.org> <4A7AA416.9070901@kernel.org> <20090806115705.GB10734@elte.hu>
In-Reply-To: <20090806115705.GB10734@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 16:15:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> for the x86 bits:
> 
>  Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> Once Dave acks it i suspect you can send it to Linus directly?

Yeap, I'll.

Thanks.

-- 
tejun
