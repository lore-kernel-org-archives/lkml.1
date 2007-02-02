Return-Path: <linux-kernel-owner+w=401wt.eu-S1423081AbXBBODe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423081AbXBBODe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423111AbXBBODe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:03:34 -0500
Received: from qb-out-0506.google.com ([72.14.204.226]:7611 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423081AbXBBODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=buA1JNgWk5Bvh4XZbK2enqZd1Au//0ofz00tSEwyYB6o8+FrePnyz6jNvviI+hmtVzBWzmILXFj1h4/8mqpbgNEMO0BbtFuijWO1PFMpO6fE60iH4CQs7dgnJQfYjhvps0oZFloLbnehc/1kglutlOVs/txLV5L4yZLDM5VcyqU=
Message-ID: <38b2ab8a0702020603h480fc1dfm22267089341cbe0e@mail.gmail.com>
Date: Fri, 2 Feb 2007 15:03:31 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Paolo Ornati" <ornati@fastwebnet.it>
Subject: Re: Slower CPU frequency reported by the kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070202130408.05212b10@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
	 <20070202130408.05212b10@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Paolo Ornati <ornati@fastwebnet.it> wrote:
>
> You are using frequency scaling(*) and "/proc/cpuinfo" reflects the
> current speed.
>

ok, I didn't know about this.

>
> (*) =
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_DEBUG=y
> CONFIG_CPU_FREQ_STAT=m
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y

it's seems that the cpu freq scaling depends on a user space tool.
Could you tell me how I can find if there're such tools installed on
my computer ?

thanks
-- 
Francis
