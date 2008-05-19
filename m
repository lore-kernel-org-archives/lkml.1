Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYESJuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYESJuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYESJt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:49:56 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:40037 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYESJtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:49:55 -0400
Date: Mon, 19 May 2008 11:49:53 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx
Subject: Re: [PATCH 1/9] Alchemy: export get_au1x00_speed for modules
Message-ID: <20080519094953.GA22445@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net> <20080519080416.GB21985@roarinelk.homelinux.net> <483149E0.6010009@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483149E0.6010009@ru.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

>> From 8492076e98c7fd47c9dee53984dbd9568ace357d Mon Sep 17 00:00:00 2001
>> From: Manuel Lauss <mlau@msc-ge.com>
>> Date: Wed, 7 May 2008 13:42:55 +0200
>> Subject: [PATCH] Alchemy: export get_au1x00_speed for modules
>>
>> au1xmmc.c driver depends on it, so export it for modules.
>>
>> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
>>   
>
>   I thought that has been merged.

Yes, Ralf merged it into linux-mips repo, but it is not yet in
mainline and the rest of the patches are against linus' git.

	Manuel Lauss
