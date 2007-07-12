Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbXGLE7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbXGLE7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 00:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXGLE7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 00:59:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:23760 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXGLE7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 00:59:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YTH2M7fQol9gottpdgVtYAyi4QVVUw0IDeHVb81zEkjY7DUIBzbjplk5HtAxsUfwZ40wHH75ArygokxvohzSwK01TPb2boUjumM2FSTctCEl4gTz++EgozuZ/q3X5MeUmWBMMErKw30/cqe81TyGVNjUAp63HkIW9D21fSXsX1U=
Message-ID: <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com>
Date: Wed, 11 Jul 2007 21:59:13 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200707111916.35036.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707111916.35036.jesper.juhl@gmail.com>
X-Google-Sender-Auth: 29540056d3147cf2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> I'm wondering if it's time to make 4K stacks the default and to start
> considering removing the 8K stack option alltogether soon?

Why? Leaving the option for 8k stacks isn't killing any kittens, AFAICS.
