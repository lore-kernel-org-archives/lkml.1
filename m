Return-Path: <linux-kernel-owner+w=401wt.eu-S1750905AbXB1FwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbXB1FwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 00:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbXB1FwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 00:52:17 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:5553 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbXB1FwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 00:52:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=k/7FCcx7QCTHRmdAH4t+i2fXd2JFDJDXSVZGvah7TSQt7R4x2CtK0rnpI6+pWXmnYkMRb2Z3T+TLEUVfSza1k8okyS9yY6PtOGwhjwwUgJlMyphWGA6TyjmHzefbQw+wTB0ADj+Un2W9tx3U6G9s7dHGF35R/EM0MytIOsT34Mc=
Message-ID: <45E5183B.6020108@googlemail.com>
Date: Wed, 28 Feb 2007 06:50:51 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070207)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Oh well.. I'm not very proud of this, because quite frankly, -rc2 has way 
> more changes than I really like.
>
>   


I got this warning so far :)

drivers/video/Kconfig:1622:warning: 'select' used by config symbol 
'FB_PS3' refer to undefined symbol 'PS3_PS3AV'


Regards,

Gabriel

