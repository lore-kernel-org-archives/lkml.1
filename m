Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbXKZTdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbXKZTdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbXKZTdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:33:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:31725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbXKZTdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Apv722H6NvcMZbvLfF4qdIWWB53xpIIcRiDL4q56D17rzQny//ohvZTRqaLIk7JhUGBm2zgBTpOrtiZ5ZI/wlGYS/pJ7aftdBBVCGcLnLik00XSfMJos1zQWGFND186pbvzJcER8NNkxQq8sG0hPx9mOgM5ZmkHgOUUygnL1ybA=
Message-ID: <474B1F6F.1090907@gmail.com>
Date: Mon, 26 Nov 2007 20:33:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	<a8e1da0711202151t6c9d52acjf1f876085b95dfce@mail.gmail.com>	<20071120220046.db5c8fde.akpm@linux-foundation.org>	<a8e1da0711202203v6a2a9945pcfa5cfe67b83b504@mail.gmail.com> <20071126134834.132c3081@cuia.boston.redhat.com>
In-Reply-To: <20071126134834.132c3081@cuia.boston.redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2007 07:48 PM, Rik van Riel wrote:
>>>> ERROR: "empty_zero_page" [drivers/kvm/kvm.ko] undefined!
[...]
> FYI, x86_64 has the exact same issue.

yes:
hot-fixes/git-x86-dont-unexport-empty_zero_page.patch

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
