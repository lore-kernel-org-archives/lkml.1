Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbXC3QiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbXC3QiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbXC3QiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:38:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:57157 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbXC3QiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AF+ePSLtYFZCCuF8bvSwGGc7k8QpbctK/7bHmWQV2zIy8ub0yGvjatIM23Db64LHctYeP4FH1baHF3oGJfjUCD/moFtnQjFw7apm6gVbboFlVnRS4UujZ68pkswpUJCTxcrOakFksLnxS7AEbm/1OwHt4cKyuL/ZKaAHpWyWwtE=
Message-ID: <d120d5000703300938j564a82bdq1e95eeab67a37221@mail.gmail.com>
Date: Fri, 30 Mar 2007 12:38:11 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5-mm3
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070330010559.2a232d9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/
>
> - git-cryptodev has things in it again
>
> - Re-added git-e1000: a large amount of e1000 driver work
>
> - git-net has a huge amount of material in it, but I dropped it because it
>  went oops.
>
> - git-block is back, minus the problematic unplugging rework.
>
> - Lots of x86 updates.
>
> - lguest is being redone and has been dropped
>
> - The IDE development tree has been restored
>

Andrew,

Did you drop git-input? I do not see it anywhere....

-- 
Dmitry
