Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZAFFOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZAFFOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 00:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZAFFOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 00:14:14 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:62424 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZAFFOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 00:14:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I8p1g+Cv1I6oNGGgRn5Jg87HIpnFAPumtwoYLW15fkXYxxcsEA1n+uWBGmdODtIuxM
         RCp7wTMltx2Js5v4cQBM+EZsaztXAcg7+uDdMKDp5jHJXTKCk0Jpv3sNiKbsRmmcpCNL
         9zo5tnwqzob/gni69ckql1dN+RhzIKuxuAYa0=
Message-ID: <3f9a31f40901052114t68cac881md439bf24b602f269@mail.gmail.com>
Date: Tue, 6 Jan 2009 10:44:11 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [GIT]: Networking
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <20090105.204934.65827705.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0901051839330.3057@localhost.localdomain>
	 <20090105.201530.195720489.davem@davemloft.net>
	 <alpine.LFD.2.00.0901052029220.3057@localhost.localdomain>
	 <20090105.204934.65827705.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2009 at 10:19 AM, David Miller <davem@davemloft.net> wrote:
>
> I had 4 firmware patches to apply, each one had to add entries
> to the same file.
>
> The first patch had to be skipped.
>

In firmware we maintain WHENCE, so every time we add new firmware we
also update WHENCE.

We are facing problems while we prepare patch for firmware as we add
new stuff at the end.
As per David Woodhouse suggestion, I arranged WHENCE to alphabetical
order by driver name to avoid conflicts.

I also send patch on 21 Dec 2008 with ack of David Woodhouse to linus
and waiting from his side.

[PATCH] firmware: Arrange WHENCE in alphabetical order to avoid conflicts

I think this will resolve very soon, once we update WHENCE in
alphabetical order, If you better suggestions, please let me know.

Thanks,
--
JSR
