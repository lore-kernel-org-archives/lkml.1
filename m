Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbYDCM0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbYDCM0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYDCM0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:26:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:13978 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYDCM0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:26:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hxAJMtKvnGL1ODatQUcdVdPLOGk7kHAtW4tRGeJ6huFS68za0wstFAPKYuvPsvGKxj6NPmus95+CsV9e/ou9y6tBbAzB+/HJc9/bdUbaw99YHjzOWwG0D7jz9BJGviA7084sY0LW0leSiBHW1z1x5ey3E3v40TtkcWjzc7vRzYY=
Message-ID: <19f34abd0804030526j3b54e4a2ya5cd22677721cd08@mail.gmail.com>
Date: Thu, 3 Apr 2008 14:26:01 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080326115853.GE22847@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080326102654.GB22847@logfs.org> <20080326112311.GG17176@elte.hu>
	 <20080326114142.GD22847@logfs.org>
	 <20080326.044802.107678511.davem@davemloft.net>
	 <20080326115853.GE22847@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m33CQJnq003607

Hi,
[Some CCs dropped. I don't think they're truly interested.]
On 3/26/08, JÃ¶rn Engel <joern@logfs.org> wrote:>  What is the reason why (void *)foo is better than (void*)foo?  Just that>  fact that by random chance one them them became more common in our>  codebase and the minority always has to give in?
I think the rationale for using (void *) over (void*) is that weusually write a space before the * in other places (again, it's aboutconsistency). Or do you also write void*a; in variable declarations?

Vegardÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
