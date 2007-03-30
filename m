Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbXC3Qb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbXC3Qb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXC3Qb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:31:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:53814 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbXC3Qb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rBn3gq4sh82cMZXPiEVt4A+YNQtynYeAdtgTjH0ZnmxJqFNmZdy9VAieLH6cGV63dFu3bemveW+0C0hvpjABcdtugGgR2nmPCQNUz/JXHvfDVMPIv01GWamjzsRluKCvBbZ2gzT8OTrLXPTvXxm+TKnunjd7l7O7xZEYpPbhN4M=
Message-ID: <6bffcb0e0703300931n1fb83ad3j2f857a8959c470b@mail.gmail.com>
Date: Fri, 30 Mar 2007 18:31:56 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5-mm3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070330010559.2a232d9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/
>

It's my lucky Friday, kernel hangs shortly after

PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12ac

due to

GOOD
mm-only-hrtimers-debug-patch.patch
mm-only-hrtimers-debug-patch-fix.patch
BAD

patches. Both patches works fine for me in vanilla tree.

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm3/mm-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm3/mm-console.log

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
