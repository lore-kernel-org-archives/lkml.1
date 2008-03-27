Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYC0RdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYC0RdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYC0Rcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:32:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:60573 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYC0Rcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=klnU2pqxhcCLnqIGSHeJnVb7Zzu60h5Cw5zntGrLaf1xdfgVNpirRN87F/IACGZWcPOzCTMKXGNNBMCwCD3tH8oh/m/Ed4gSJubTzYBU+dqDwjdsua2dpEMAAmCXFzjJ5me4iNrSpoZ2eyTGuYmufZLx1zUs6qlrGd8AHRkVlyg=
Message-ID: <2f11576a0803271032q71990743ub79761afe99cc595@mail.gmail.com>
Date: Fri, 28 Mar 2008 02:32:47 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 103 sec. latency: sync_page() with TASK_UNINTERRUPTIBLE (?) (bisected)
Cc: kosaki.motohiro@jp.fujitsu.com, "Carlos R. Mafra" <crmafra2@gmail.com>,
       linux-kernel@vger.kernel.org, riel@redhat.com, rjw@sisk.pl,
       kosaki.motohiro@gmail.com
In-Reply-To: <20080323174142.B31A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080323034725.GA3781@localhost.ift.unesp.br>
	 <20080322224143.0e2901cd.akpm@linux-foundation.org>
	 <20080323174142.B31A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: 7d81f0bc0771974a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  if you don't mind, I hope join to test to this patch.
>  I think his basic idea is good.
>  but unfortunately, it has corner case problem.
>  if do more test and remove any regression, this patch is valuable
>  for merge again.

I tried reproduce this problem long time with Carlos's big help.
but unfortunately I can't it.

if anyone can reproduced it, please contact me.

Thanks!
