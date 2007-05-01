Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbXEAUEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbXEAUEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXEAUEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:04:41 -0400
Received: from khc.piap.pl ([195.187.100.11]:59438 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbXEAUEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:04:39 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 23/36] Use menuconfig objects II - netdev/wan
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704301345101.29151@yvahk01.tjqt.qr>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 01 May 2007 22:04:37 +0200
In-Reply-To: <Pine.LNX.4.61.0704301345101.29151@yvahk01.tjqt.qr> (Jan Engelhardt's message of "Mon, 30 Apr 2007 13:45:51 +0200 (MEST)")
Message-ID: <m37irsux7u.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

> Change Kconfig objects from "menu, config" into "menuconfig" so
> that the user can disable the whole feature without having to
> enter the menu first.
>
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
> ---
>  drivers/net/wan/Kconfig |   34 +++++++++++++++-------------------

Looks good.
-- 
Krzysztof Halasa
