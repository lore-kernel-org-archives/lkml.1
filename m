Return-Path: <linux-kernel-owner+w=401wt.eu-S936201AbXGLDE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936201AbXGLDE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 23:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764229AbXGLDES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 23:04:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:63389 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760236AbXGLDER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 23:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=D9G++tY/N3U/NU8cAZAuaFALhjD2/KCS3G9IH35oUme6wssqDkOfUjped1mZYmYWPlWDQ9MqhQG1pstD917ASKjb7d3y6oER9/7OLJ3DVq+wSoTkEEl+PWw8oo713Yj3FrCJZRqclXe/ArU3r6BZgDgKjYpmtxFSGcn8+Qw8GTI=
Message-ID: <46959A2C.7090908@gmail.com>
Date: Thu, 12 Jul 2007 12:04:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226
 SS:ESP 0068:c5ff9db8
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>	 <a44ae5cd0707040036x74c82dcci12b0a3f83a27af56@mail.gmail.com>	 <468C9E74.4080606@gmail.com>	 <a44ae5cd0707060101g38147b2gb3d33d9903082113@mail.gmail.com>	 <468F36F5.4010803@gmail.com>	 <a44ae5cd0707071753g6dd4445bsaac2e2296327e510@mail.gmail.com>	 <469038EF.7040709@gmail.com>	 <a44ae5cd0707072156y7d0c9e5am2ded3efdc036bcf7@mail.gmail.com>	 <469484E1.6040000@gmail.com> <4694A769.7040502@gmail.com> <a44ae5cd0707111539l5e5adc4ct76ae2f4cb9063e58@mail.gmail.com>
In-Reply-To: <a44ae5cd0707111539l5e5adc4ct76ae2f4cb9063e58@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> Does this patch replace or add to the last patch you sent me?
> I'll try applying them with --dry-run and assume that if #1 + #2
> doesn't apply cleanly, then you only want me to test with this
> latest patch.

This replaces the old one.  Just revert the old one and apply this one.

> I'll be able to test this later this evening.  I've had house guests and
> so haven't been available the last few days.

Yeap, I'll wait for the result.  Thanks a lot.

-- 
tejun
