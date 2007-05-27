Return-Path: <linux-kernel-owner+w=401wt.eu-S1751482AbXE0HST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbXE0HST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 03:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbXE0HSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 03:18:11 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33759 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbXE0HSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 03:18:09 -0400
Date: Sun, 27 May 2007 09:17:17 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Subject: Re: BUG in kcryptd?
In-Reply-To: <Pine.LNX.4.61.0705161751020.9570@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0705270916370.7344@yvahk01.tjqt.qr>
References: <464B1F2B.3030009@xs4all.nl> <Pine.LNX.4.61.0705161751020.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 16 2007 17:52, Jan Engelhardt wrote:
>On May 16 2007 17:11, Udo van den Heuvel wrote:
>>
>>While opening an encrypted partition and trying to fsck it:
>
>Yeah, somewhere is a bug in it, I also get an oops with
>kcryptd in 2.6.20 on sparc64 after a few minutes (though,
>it's a NULL dereference there).

...which also seems to be gone for me with some 2.6.21.



	Jan
-- 
