Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbXBTKya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbXBTKya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 05:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932875AbXBTKya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 05:54:30 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:20103 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872AbXBTKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 05:54:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S/G81t1GGByE6Ojwo/M5jUosKPFIjx7IznHAiJGzVO1M/qesqJwgrF7S29WQEh8QECQhd/d/qRHqCs0Dt53UILuxWHyeQNNWfzDASYe3g6fOQoDxOSO/HFbhbpR6OsoKaEHnVXasIhYPxE6c48IIKiN9FLgZowjlrbY2zcqaoLg=
Message-ID: <3a5b1be00702200254t1afd1c52u2e7401a4ab6c240f@mail.gmail.com>
Date: Tue, 20 Feb 2007 16:24:28 +0530
From: "Komal Shah" <komal.shah802003@gmail.com>
To: Maximus <john.maximus@gmail.com>
Subject: Re: irqdesc porting help
Cc: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       arjan@infradead.org
In-Reply-To: <3634de740702192303xea41f14i9f613fac2725b0ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com>
	 <20070215103347.GA18690@linux-sh.org>
	 <3634de740702192303xea41f14i9f613fac2725b0ca@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maximus,

On 2/20/07, Maximus <john.maximus@gmail.com> wrote:
> Hi,
>   Sorry for the late response, attached is the code im trying to port
> to linux - 2.6.20.
>
>

Have you checked http://source.mvista.com/git linux-omap-2.6 git tree.
Syed Khasim has already submitted this OMAP2430 TWL4030 chip core
driver there, which is already synced with 2.6.20.

-- 
---Komal Shah
http://komalshah.blogspot.com
