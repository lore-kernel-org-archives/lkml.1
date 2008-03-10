Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbYCJLmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbYCJLmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYCJLm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:42:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:64196 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYCJLm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pTCdevWk4v9cWSdAAay+DN6/JmYogAYzRoPhRrFrt0T2imcoHqpAl/JxjziKNCbPjd7k3FcCC9RVwg9X6p7npf4cS1OtuCniWTmiLZpC2wqdFGTamR6AFL97Kg3ILfDMFSkCk0fejVqjdtOIQKm7IXLT8/Ihz4Yj9dNKzDgwQ7E=
Message-ID: <47D51E9A.1070301@gmail.com>
Date: Mon, 10 Mar 2008 20:42:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ATA: logical-bitwise and confusion in ahci_save_initial_config()
References: <47D44BC0.2090906@tiscali.nl>
In-Reply-To: <47D44BC0.2090906@tiscali.nl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> logical-bitwise & confusion
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Acked-by: Tejun Heo <htejun@gmail.com>

Thanks for spotting this.

-- 
tejun
