Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXERK60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXERK60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbXERK6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:58:20 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:52055 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960AbXERK6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:58:19 -0400
Message-ID: <464D86BA.3070309@tobbe.nu>
Date: Fri, 18 May 2007 12:58:02 +0200
From: Tobias Bengtsson <tobbe@tobbe.nu>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>, devmnt@gmail.com
CC: Philip Langdale <philipl@overt.org>, sdhci-devel@list.drzeus.cx,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sdhci: Add quirk to support polling for card presence
References: <46479D59.4020400@overt.org> <464CDEAD.6090106@drzeus.cx>
In-Reply-To: <464CDEAD.6090106@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman skrev:
> Tobias, did you test this patch and did it solve your problem?
>   
I compiled it with 2.6.21-mm2 and 2.6.22-rc1 but both of them hangs at 
startup after setting up portmap. So atleast init starts.. I suppose I 
should set up remote syslog to debug.. and ofcourse apply the patch to a 
vanilla 2.6.21, but right now I have a lot to do.

I know at least one other person with the same hardware who also run 
linux, devmnt@gmail.com
, perhaps someone could help him apply the patch if he is williing..

regards Tobias
