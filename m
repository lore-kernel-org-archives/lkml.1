Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYLPR0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYLPR0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYLPR0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:26:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:10953 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYLPR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:26:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ncG7+NxEQRv3Pp1NChyarLeVm0SaX6wlRtfJckIhbeUBFIWJFyClZdkfZxK88Ii7HN
         2c0L0nBiSS6sc2bSag1tL/Xr0RE0NAlchovzWwmwavmdeJ5n66d7ObgnUhY0kjPwPPGS
         DEKeBxfx7ERsa2s7NaIGJMbQI5O+VdjVMJqH8=
Message-ID: <e9e943910812160926j64fa298ciae20696cd353c125@mail.gmail.com>
Date: Tue, 16 Dec 2008 17:26:03 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/8, v3] ensure symlinks are NUL-terminated
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Evgeniy Dushistov" <dushistov@mail.ru>
In-Reply-To: <1229447007.3751.1.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
	 <1229447007.3751.1.camel@norville.austin.ibm.com>
X-Google-Sender-Auth: 8e58d67763ec61a6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/16 Dave Kleikamp <shaggy@linux.vnet.ibm.com>:
> Duane,
> I see you left out jfs, so I'm assuming you're letting me handle that
> one.  I've push my patch upstream, so it should show up in the -next
> tree.

That's right, since jfs doesn't need the helper and your patch was a
full and complete fix. I should have clarified whether that was how
you wanted it handled, sorry.

Which reminds me, I need to follow up about the original befs and 9p
patches which didn't make it to the list and haven't been ACKed or
NAKed yet...

> Shaggy

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
