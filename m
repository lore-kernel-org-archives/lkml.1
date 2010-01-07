Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583Ab0AGNpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0AGNpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266Ab0AGNpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:45:51 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:47549 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab0AGNpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:45:51 -0500
Subject: Re: vfs related crash in 2.6.33-rc2
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Marvin <marvin24@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
In-Reply-To: <201001071027.58865.marvin24@gmx.de>
References: <200912301733.19077.marvin24@gmx.de>
	 <20100106154123.b12547f3.akpm@linux-foundation.org>
	 <1262822158.4251.179.camel@localhost>  <201001071027.58865.marvin24@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 08:45:43 -0500
Message-ID: <1262871943.3309.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 1 sum rcpts/h 8 sum msgs/h 1 total rcpts 2184 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: A142186A0A906D42BB5B0A5411EC90BAEF6E32AD
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 81 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 10:27 +0100, Marvin wrote: 
> It seems that I send the reply to Hirofumi only, sorry for that. The patch works fine 
> - no oops anymore.

OK. Thanks for testing!

Trond

