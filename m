Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYJOXyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYJOXyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYJOXxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:53:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:21031 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYJOXxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:53:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Brod604WjywMdQywRCP9x5jwXL93T6Dw12qh1E2HrPzm6HtHwMnTAYcitJRZh13h0z
         zH6DqnzFATcQ4EIuZhC1HocG0xc81Go+WqflLWCapIhRIRuuWBcpunxL435Afr3NNu79
         QO66sZ2HLXchUlaLvCMU6igrdrkv/t//PY5oo=
Message-ID: <12c511ca0810151653p535d5ae4j297cf5b41900a4ba@mail.gmail.com>
Date: Wed, 15 Oct 2008 16:53:51 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: is the weeks before -rc1 the time to really be working on -next?
Cc: "David Miller" <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       greg@kroah.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081015164139.ebcd24c6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081015145606.2af3baf1.akpm@linux-foundation.org>
	 <20081015233607.54c1d6b8@lxorguk.ukuu.org.uk>
	 <20081015155353.f15a996e.akpm@linux-foundation.org>
	 <20081015.160821.143702739.davem@davemloft.net>
	 <20081015164139.ebcd24c6.akpm@linux-foundation.org>
X-Google-Sender-Auth: efc006d1a8a07a07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but then people would end up being based on linux-next, and that's
> a pretty rubbery target with all the rebasing and trees getting
> dropped, etc.  And they'd accidentally end up having to actually
> compile and run linux-next, shock-horror-oh-the-humanity.

I built and booted linux-next a couple of times a week or so
for ia64.  Most of the time it worked just fine.  I found a few
build problems, but only three run-time problems. My boot
log shows 49 successful boots of linux-next based kernels
from 2.6.25-rc2 to 2.6.27-rc6

But perhaps less people are working on breaking ia64 :-)

-Tony
