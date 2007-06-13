Return-Path: <linux-kernel-owner+w=401wt.eu-S1759733AbXFMRSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbXFMRSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758945AbXFMRR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:17:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:5080 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938AbXFMRR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pv6fzZo5J8VFIrkW9mt3P4C0ObxQz+4M1pGGTuszn6SYNtyaMgXL06Juo/RPG9MhbunDWTZMvI7C12ThuOkAsEexQ/KnTVeGul1JTTROorGf8MjdxsKqhhapMgHawnsJ+C+izzLdZ2j2uLQhgOTDeRDjjMqCybxNlvlg9mnFaj0=
Message-ID: <a781481a0706131017k368b6388n524cc2d3801be861@mail.gmail.com>
Date: Wed, 13 Jun 2007 22:47:56 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Keiichi KII" <k-keiichi@bx.jp.nec.com>
Subject: Re: [RFC][PATCH -mm take5 7/7] update documentation
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <466FC79F.7090805@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FC455.5060001@bx.jp.nec.com> <466FC79F.7090805@bx.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/13/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> From: Keiichi KII <k-keiichi@bx.jp.nec.com>
>
> update Documentation/networking/netconsole.txt
>  - how to use sysfs for dynamic configurability
>  - how to use ioctl for dynamic configurability
>
> Signed-off-by: Keiichi KII <k-keiichi@bx.jp.nec.com>

Ah, so here comes the documentation :-) Actually, I've seen a lot
of patchsets these days that prefer to submit the documentation
patch in the beginning, so that a reader / reviewer can get ready
about what to expect from the code.

Anyway, I really liked your submission. It makes netconsole
quite flexible and powerful, indeed.

Thanks,
Satyam
