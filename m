Return-Path: <linux-kernel-owner+w=401wt.eu-S1761062AbXGTDXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761062AbXGTDXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXGTDWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:22:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:48815 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbXGTDWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ooLipdXS5eGLxodwn97dNmFaWkBVjIAwBzvkj9F87ZB6fUNWYmeLcCjoleHi6Fb+tMNVhf2VbHsir674Z5scF2yB4UxaL0a6J3gxylb7BkepcBYsh4kqs06fzaLP94gg6Hb8ofN2A7TVdduix8lxun883wyudXu9QRlpXPiq7a0=
Message-ID: <91b13c310707192022mf16cfefg8e05077697a4fef0@mail.gmail.com>
Date: Fri, 20 Jul 2007 11:22:52 +0800
From: "rae l" <crquan@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] net/core: merge the content of dev_mcast.c into dev.c
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, kaber@trash.net,
       pekkas@netcore.fi, jmorris@namei.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070719.200459.41636483.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070718.030306.50591269.davem@davemloft.net>
	 <1184758229305-git-send-email-crquan@gmail.com>
	 <91b13c310707191851h3bffaf2au7443d32c725dfb45@mail.gmail.com>
	 <20070719.200459.41636483.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, David Miller <davem@davemloft.net> wrote:
> Please don't quote a big huge patch just to say one sentence that
> doesn't apply to any particular specific part of a patch.
>
> That's wastes bandwidth, annoys people you might actually want
> a response from, and is bad netiquette in general.
Thanks.

>

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
