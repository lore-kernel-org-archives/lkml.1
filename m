Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbXDAJQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbXDAJQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 05:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbXDAJQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 05:16:17 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:46017 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbXDAJQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 05:16:16 -0400
Date: Sun, 01 Apr 2007 11:16:14 +0200
Message-Id: <1713525762@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit 
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Remove artificial maximum 256 loop device that can be created due to a
>legacy device number limit.  Searching through lkml archive, there are
>several instances where users complained about the artificial limit
>that the loop driver impose.  There is no reason to have such limit.

Hey, i was one of those :)

Nice to see, that it`s solved now, thanks very much!

I never expected this to happen and put all my hope into dm-loop instead.
Did you mind that Bryn m. Reeves from redhat will suffer a serious depression now? ( ->  http://sources.redhat.com/lvm2/wiki/DMLoop ) ;)

regards
roland

_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

