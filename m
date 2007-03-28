Return-Path: <linux-kernel-owner+w=401wt.eu-S1751626AbXC1Njn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbXC1Njn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXC1Njn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:39:43 -0400
Received: from smtp.nokia.com ([131.228.20.171]:62866 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbXC1Njm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:39:42 -0400
X-Greylist: delayed 2070 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2007 09:39:42 EDT
Message-ID: <460A6669.8030605@nokia.com>
Date: Wed, 28 Mar 2007 15:58:17 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [-mm patch] drivers/mtd/ubi/: make code static
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <20070328121141.GQ16477@stusta.de>
In-Reply-To: <20070328121141.GQ16477@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Mar 2007 12:58:18.0009 (UTC) FILETIME=[C1653090:01C77138]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes needlessly global code static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Thanks, will be fixed.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
