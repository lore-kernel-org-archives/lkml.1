Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYLMNP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYLMNP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 08:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbYLMNPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 08:15:49 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:51639 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbYLMNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 08:15:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c1ErUmr0pICcBOowO172eVpc8PrCcTla5pozT+1tctdFIKiKXIOyd4/5lmX8A60hS/
         +QrStuWt2Yw5MnKsLoO4qn8smc34In+/c3AAXJPH20jLRXdAQ21XX0sg2Lf3ftPi7aCT
         VtDWQqghRjqZz6rNWIUK3B7uQrNBU+lkZvi9E=
Subject: Re: Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, ath5k-devel@venema.h4ckr.net,
       alsa-devel@alsa-project.org
In-Reply-To: <491506DB.1070000@gmail.com>
References: <491506DB.1070000@gmail.com>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 15:15:38 +0200
Message-Id: <1229174138.24940.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So, big thanks for everything.

Now aspire one linux support is very close to perfect,
(only problem left is that wireless is limited to 18Mbits/s raw rate,
but at some point I or developers of ath5k will get to the bottom of
this)

I also noticed, that now the SD only card reader is always enabled
regardless of card been there while booting, and same happens in
windows, I suspect that this is permanent hardware change, which worries
me, but this reader works fine otherwise.
(This is another reason why binary bioses are evil, go and find out why
it enables it)


Also forgot to mention that both readers ignore write protect tab on SD
card, and I will report this to correct mailing list soon.
Everything else works fine

please include acpiphp fix in 2.6.28.
Also I applied patch to coretemp to make it show cpu temperature.

Thanks again,
	Maxim Levitsky

