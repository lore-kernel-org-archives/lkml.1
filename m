Return-Path: <linux-kernel-owner+w=401wt.eu-S934507AbXGSFKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507AbXGSFKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 01:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXGSFKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 01:10:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:2033 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbXGSFK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 01:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=D/kuAXiSxlnK1XYR04I2auxwt4aIj7m9WfKWXTGagseY0Zyjo8h1u9Efp3wZpmWKGjSp6ZM5q5Z5w9pdpEcCnXOQnJausXNOnoNu4aAEingGocfJYZIP+VDNdP5C6wHr3IihgnMnXdTEuiD5ZJbQzr58Jf1njUOzi/t4EohGCbM=
Date: Thu, 19 Jul 2007 13:12:54 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Li Yang <leoli@freescale.com>, TripleX Chung <xxx.phy@gmail.com>,
       Maggie Chen <chenqi@beyondsoft.com>
Subject: Re: [PATCH 3/5] HOWTO: add Chinese translation of Documentation/HOWTO
Message-ID: <20070719051254.GA2736@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070718232346.GB4620@kroah.com> <11848012031961-git-send-email-gregkh@suse.de> <11848012093296-git-send-email-gregkh@suse.de> <11848012151444-git-send-email-gregkh@suse.de> <9a8748490707181646k1e062a75n86408cd88ef16193@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a8748490707181646k1e062a75n86408cd88ef16193@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 01:46:08AM +0200, Jesper Juhl wrote:
>On 19/07/07, Greg Kroah-Hartman <gregkh@suse.de> wrote:
>>From: Li Yang <leoli@freescale.com>
>>
>>This is a Chinese translated version of Documentation/HOWTO.  Currently
>>Chinese involvement in Linux kernel is very low, especially comparing to
>>its largest population base.  Language could be the main obstacle.  Hope
>>this document will help more Chinese to contribute to Linux kernel.
>>
>>Signed-off-by: Li Yang <leoli@freescale.com>
>>Signed-off-by: TripleX Chung <xxx.phy@gmail.com>
>>Signed-off-by: Maggie Chen <chenqi@beyondsoft.com>
>>Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>>Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>---
>> Documentation/zh_CN/HOWTO |  536 
>> +++++++++++++++++++++++++++++++++++++++++++++
>> 1 files changed, 536 insertions(+), 0 deletions(-)
>> create mode 100644 Documentation/zh_CN/HOWTO
>>
>>diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
>>new file mode 100644
>>index 0000000..239f454
>>--- /dev/null
>>+++ b/Documentation/zh_CN/HOWTO
>>@@ -0,0 +1,536 @@
>>+Chinese translated version of Documentation/HOWTO
>>+
>>+If you have any comment or update to the content, please contact the
>>+original document maintainer directly.  However, if you have problem
>
>s/if you have problem/if you have a problem/  ???

Yes! Thank you.

>
>>+communicating in English you can also ask the Chinese maintainer for
>>+help.  Contact the Chinese maintainer, if this translation is outdated
>
>I believe the "," should be removed.
>

ACK.

>
>>+or there is problem with translation.
>
>Wouldn't "or if there is a problem with the translation." be better?

Yes. IMO, it's really better. ;)

>
>>+
>>+Maintainer: Greg Kroah-Hartman <greg@kroah.com>
>>+Chinese maintainer: Li Yang <leoli@freescale.com>
>>+---------------------------------------------------------------------
>>+Documentation/HOWTO µÄÖÐÎÄ·­Òë
>>+
>
><snip - I can't read Chinese, so no comments on that part>

Thanks again for your comments.

Since these docs are not in the mainline tree yet, I don't have a copy.

Li Yang, could you please apply these changes?

-- 
To do great work, you have to have a pure mind. You can think only about the
mathematics. Everything else is human weakness. Accepting prizes is showing
weakness.

