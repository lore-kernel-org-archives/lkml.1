Return-Path: <linux-kernel-owner+w=401wt.eu-S968254AbXEHUTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968254AbXEHUTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966726AbXEHUTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:19:39 -0400
Received: from smtp3.nextra.sk ([195.168.1.142]:4963 "EHLO mailhub3.nextra.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966715AbXEHUTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:19:38 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 16:19:38 EDT
From: Ondrej Zary <linux@rainbow-software.org>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: New Mitsumi legacy CD-ROM driver
Date: Tue, 8 May 2007 22:13:43 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <464045F0.3040906@gmail.com>
In-Reply-To: <464045F0.3040906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705082213.44042.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 May 2007 11:42:08 you wrote:
> Mitsumi (mcdx, this driver), panasonic (sbpcd) and sony (cdu31a) are
> somewhat of an exception in so far that controllers for those three are
> still around on a lot of old ISA soundcards though. Moreover, I have the
> drives to test that trio so after this mitsumi driver is complete and in
> good shape I'll do the other two as well.

I fixed cdu31a some time ago - so it at least works.
I also have a Panasonic drive with controller integrated on a SB16 sound card 
but haven't tried it with Linux yet.

It's nice to see new driver for these old drives.

-- 
Ondrej Zary
