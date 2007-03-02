Return-Path: <linux-kernel-owner+w=401wt.eu-S2992761AbXCBXmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992761AbXCBXmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992762AbXCBXmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:42:40 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:28138 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992761AbXCBXmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:42:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OtsTmCw4zY+8/ym/+0ausUbzHwmm6lsIJg78rnRuyLtH4qAi8Rnsq7CGIDZnPWKEVAMgR0W/bXb1fcR+55pQnK9cBnk4WEuls+jnHiUf8L8vh6Rpna7Gi6F9i4kFo2oxSGOvtR5SxRm3d4gCopQlSQ4RUVMMi8Iohbi/t206Hhk=
Message-ID: <6bffcb0e0703021542k4f882531r21807c7efdbd0ebc@mail.gmail.com>
Date: Sat, 3 Mar 2007 00:42:33 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc2-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Temporarily at
>
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
>

I have noticed some strange system behavior. When i try to build a
kernel (medium load) - X, keyboard, mouse and sound hangs.

I can ping machine and I can use magic SysRq key, but that's all.

2.6.20-mm2 was fine, 2.6.21-rc2 works well (over 800 patches since
2.6.20-mm2 - great...)

NIL (Nothing Interesting in Logs)

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
