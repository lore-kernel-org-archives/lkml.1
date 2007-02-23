Return-Path: <linux-kernel-owner+w=401wt.eu-S1750772AbXBWDKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750772AbXBWDKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXBWDKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:10:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:56177 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXBWDKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:10:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JbfpMQ5ZFu+82wLMmDoofozkes4oRusG4P7YsnDQfRcDKAIYF9Q3Sv4UhVPZ5/x9P2tVGuTH4hWKj1jfHiOQi949giTarkDM6zxap3d4tlPSGxj7e/HgsXaMvqJ+RDjF6YAqmvvDdSgAHfvEpwxtXxgTwSnXDC4ju7h67tR/OPs=
Message-ID: <a2ebde260702221910q1da29a21r947bf7999f51d6c6@mail.gmail.com>
Date: Fri, 23 Feb 2007 11:10:33 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: Why __syscallN macros are removed?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702221903490.1356@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a2ebde260702221847q6710be1sbf2d28f37ab4fb2b@mail.gmail.com>
	 <Pine.LNX.4.64.0702221903490.1356@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much.


2007/2/23, Davide Libenzi <davidel@xmailserver.org>:
> On Fri, 23 Feb 2007, Dong Feng wrote:
>
> > The __syscallN series macros have disappeared in
> > include/asm-i386/unistd.h. Why? I occasionally what to add and use
> > some new system calls, mainly for debug use. Now I can not access the
> > system call I added from user space.
>
> You can use glibc's syscall(2) instead of macros.
>
>
>
> - Davide
>
>
>
