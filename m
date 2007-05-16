Return-Path: <linux-kernel-owner+w=401wt.eu-S1761891AbXEPLjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761891AbXEPLjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbXEPLjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:39:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:54885 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758359AbXEPLjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Xna+Nk1k+zq5tZ+DatSixdYpO0q2RNIVJR6wxpJ625S0xnOoIW629mh2hjarJlmJgMJNdc+q8oGTMMKuPNv2mpQQ6dkVglz+7cIVY+Cj6WZGMPHET7PSpELdavxb3U5YktKcbfbBXPjvb5dnmn0i6fFzaMKO+pegkorTz22ajpo=
Message-ID: <464AED48.30200@gmail.com>
Date: Wed, 16 May 2007 13:38:48 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Tejun Heo <htejun@gmail.com>,
       Francesco Pretto <ceztko@gmail.com>, Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca> <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com> <463B858E.6060002@cfl.rr.com> <463B99EE.2090001@gmail.com> <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com> <46489D3B.8050805@gmail.com> <20070515210804.GG25902@redhat.com>
In-Reply-To: <20070515210804.GG25902@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> There's a typo..
> 
> "Check whether /sys/modules/libata/parameters/spindown_compat  exists. If it does, write 0 to it."
> 
> should be /sys/module/libata/parameters/spindown_compat

Right, thanks.

-- 
tejun
