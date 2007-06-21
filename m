Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbXFUPQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbXFUPQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXFUPQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:16:45 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:36716 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXFUPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=H1cD3QcUOARZbiByoYWKoeRs04GzJHLu9+9eFSWHG2GUYAFIKNG1dpDbzBHrXIuEbNPjQSF6tvR1s+q96AawV5d35g1AFU5QaK3pDTeelkQIjO+7YWy+pkVJRySH9LdOuHqQt8uD7OxLklsOSJiacp67bWivAVj78CTj2CMH/us=
Date: Thu, 21 Jun 2007 23:18:20 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Li Yang <leoli@freescale.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, bryan.wu@analog.com,
       TripleX Chung <xxx.phy@gmail.com>, Maggie Chen <chenqi@beyondsoft.com>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Message-ID: <20070621151820.GA10363@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <1182436817579-git-send-email-leoli@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182436817579-git-send-email-leoli@freescale.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 10:40:17PM +0800, Li Yang wrote:
>This is a Chinese translated version of Documentation/HOWTO.  Currently
>Chinese involvement in Linux kernel is very low, especially comparing to
>its largest population base.  Language could be the main obstacle.  Hope
>this document will help more Chinese to contribute to Linux kernel.
>
>Signed-off-by: Li Yang <leoli@freescale.com>
>Signed-off-by: TripleX Chung <xxx.phy@gmail.com>
>Signed-off-by: Maggie Chen <chenqi@beyondsoft.com>


Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
>Address comments from Wang Cong.
> Documentation/zh_CN/HOWTO |  536 +++++++++++++++++++++++++++++++++++++++++++++
> 1 files changed, 536 insertions(+), 0 deletions(-)
> create mode 100644 Documentation/zh_CN/HOWTO
>
>diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
>new file mode 100644
>index 0000000..c70debd
>--- /dev/null
>+++ b/Documentation/zh_CN/HOWTO


Thanks! Looks fine for me this time.

However, I have noticed this patch for original HOWTO:
http://lkml.org/lkml/2007/6/19/299

Maybe we can ask Greg if that patch has applied. If so, we should also change ours.


