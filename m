Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbXCGQ3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbXCGQ3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932744AbXCGQ3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:29:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:7932 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbXCGQ3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:29:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MWAZq1wxqLIbxTnvADxIZpMYU32uwRMWPpzkXc8ZZ8gQCgjpTO3RNa6w3bDfLQhW+zV99Hm4A/wvs+I1Kj79/9i0uNHl4uHJ83f7gFKeS0kP51bN4dOrUhMB0ODEer3BhhprwvFYXH6tdW8990trPNU9nczR9Mz9nYWz1hTStDk=
Message-ID: <75b66ecd0703070828l172ebd4s2350200b2020d46f@mail.gmail.com>
Date: Wed, 7 Mar 2007 11:28:55 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: Mockern@yandex.ru
Subject: Re: pxa.c cat problem
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45EED4EB.000002.11493@mfront7.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45EED4EB.000002.11493@mfront7.yandex.ru>
X-Google-Sender-Auth: 5ab628057fef8c87
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Mockern <Mockern@yandex.ru> wrote:
> Hi,
>
> I have two PXA Linux boards, I connected them and tried cat myfile > /dev/ttyS0 on  one board and cat < /dev/ttyS0 on another. But I can't see nothing.
>
> What is wrong with my pxa.c driver?

Impossible to tell without seeing the driver source which you seem to
be unwilling to post.

Lee
