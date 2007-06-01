Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbXFADwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbXFADwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 23:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbXFADwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 23:52:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:4912 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbXFADwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 23:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gxvVB8GQM8VNiBz6XyjA7QhP64lpNilaFBsuwiIndBlJmdKNcUnZmbbh35UhAiehiBQq9mckUf+QOXl4v6+aEXRn0D8cVSnDR3nLHJQu7fgXKRix0KWemE/EyiPKzJIKWBnofzbmbYzXff3m/VoIXQMN8xMFF3QH1bsZMZh4XxE=
Message-ID: <dc1166600705312052j490b1fads17e190249d178406@mail.gmail.com>
Date: Fri, 1 Jun 2007 13:52:28 +1000
From: "Michael Ellerman" <michael@ellerman.id.au>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc3-mm1
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
X-Google-Sender-Auth: 29706024a83b51ea
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
...
> +msi-fix-the-ordering-of-msix-irqs.patch
> +msi-mask-the-msix-vector-before-we-unmap-it.patch
...
>  2.6.22 probable-queue

I think these two should be in the 2.6.22 definite-queue, unless Eric disagrees.

cheers
