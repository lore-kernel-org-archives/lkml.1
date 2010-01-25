Return-Path: <linux-kernel-owner+w=401wt.eu-S1752258Ab0AYVMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0AYVMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550Ab0AYVMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:12:22 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:49511 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0AYVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:12:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=g3zVdEW3dwIAql2jB48PvbuxUxd/SzXd9pHNrdQBQWLBleQsc4XKgTKOstAeDvQdh8
         gkznozzprS0Bc1l4ptYrnaEXIV1E6RwEKfCsk1s+m8yxuTgzs+MGtFnwnHvNk7N19W2t
         2d8TOt9+UsKobhgx2G+Z2HSVLqV8qZoZf5Dgc=
Message-ID: <4B5E092B.3070801@gmail.com>
Date: Mon, 25 Jan 2010 16:12:11 -0500
From: Vikram Dhillon <opensolarisdev@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8pre) Gecko/20100120 Shredder/3.0.2pre
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Eric Miao <eric.miao@marvell.com>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] RFC: make struct platform_driver.id_table const
References: <1264179837-22999-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100125013421.GL26562@trinity.fluff.org> <4B5CFEBE.2070906@gmail.com> <20100125074242.GA12480@pengutronix.de>
In-Reply-To: <20100125074242.GA12480@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 02:42 AM, Uwe Kleine-König wrote:
> Hi,
>
>    
>> Look alright here too :) so:
>> Cc: Vikram Dhillon<dhillonv10@gmail.com>
>>      
> You mean Acked-by: Vikram Dhillon<dhillonv10@gmail.com>  ?
>
> Best regards
> Uwe
>
>    
Sorry about that stupid mistake, was a little sleepy when I typed this 
message before:

Acked-by: Vikram Dhillon <dhillonv10@gmail.com>

--
Regards,
Vikram Dhillon
