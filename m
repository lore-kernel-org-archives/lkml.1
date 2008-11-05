Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYKEPXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYKEPXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 10:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYKEPXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 10:23:23 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:31770 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYKEPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 10:23:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pM0qkciwkiuM6iiAnwl5V6T0P1i++/lqiWn5mcb7VAIeTy9vJkzWt/Rl/tF66O4h1l
         PbxLwTz8squVxWAoZGi/WAIRZbUsBElVeVTZJb8iuenRTw35oYJdJFjDpnMEk2uUFrgL
         ods2o/zyJKDKLDfGq9H4skZqXSfziDS46liKY=
Message-ID: <bc64b4640811050713i4cfb1216x822274150e929e02@mail.gmail.com>
Date: Wed, 5 Nov 2008 18:13:19 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Russell King" <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, "Cyril Hrubis" <metan@ucw.cz>,
       thommycheck@gmail.com
In-Reply-To: <20081105142329.GA1724@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031150601.GA1457@ucw.cz> <20081105142329.GA1724@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/5 Pavel Machek <pavel@suse.cz>:
> On Fri 2008-10-31 16:06:01, Pavel Machek wrote:
>> Hi!
>>
>> ...unfortunately, 2.6.27 contains the 'reset floating' bug, and from
>> the point 'reset floating' is fixed, to 2.6.28-rc1, tree will not
>> compile, so bisect is quite hard to do. Any ideas?
>
> It is still there in -rc3... And yes, it is a regression from 2.6.27.

Would you be so nice to provide a boot log of 2.6.28-rc3 with
CONFIG_DEBUG_DRIVER enabled?
Thank you.

-- 
With best wishes
Dmitry
