Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYL1WTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYL1WTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 17:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYL1WTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 17:19:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:16720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbYL1WTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 17:19:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Mh/hG+eVt2zwz9XHxOOYejSwYCAjgkFTMmnhdUrXAn+i2i27ft7C0i0+793voMi/RE
         YBdEmhDI2SRTlGD7085nK6zO1p7Kmk9cyv3R9i/mL55IfTvVZuSoKeFbE9YqJn4FfcRg
         16OuAv6dRCQA0ntYECD0IzMCZnOj9j766LkKk=
Message-ID: <4d8e3fd30812281419y4d40a78fha3eb7bc05e55e8ef@mail.gmail.com>
Date: Sun, 28 Dec 2008 23:19:29 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [1/9] pohmelfs: documentation.
Cc: "Pavel Machek" <pavel@suse.cz>, "Evgeniy Polyakov" <zbe@ioremap.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, pohmelfs@ioremap.net,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20081228134155.GB858@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230301130-1325-1-git-send-email-zbe@ioremap.net>
	 <1230301130-1325-2-git-send-email-zbe@ioremap.net>
	 <20081226192219.GB1761@ucw.cz> <20081228134155.GB858@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/08, Evgeniy Polyakov <zbr@ioremap.net>
>
>> > + * Very high performance.

Evgeniy,
Performance seems to be the most important argument in favour of pohmelfs.
You should probably add more performance data in the cover letter of
the patch serie. All the information are already available but not
easy to be reached.
In short, try to do a better work in "selling" your product :-)


Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
http://mypage.vodafone.it/
