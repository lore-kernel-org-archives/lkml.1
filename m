Return-Path: <linux-kernel-owner+w=401wt.eu-S1422672AbXBUQqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422672AbXBUQqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422678AbXBUQqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:46:47 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:33551 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422675AbXBUQqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:46:46 -0500
Date: Wed, 21 Feb 2007 17:46:30 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Robinson <andrew.rw.robinson@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel oops in 2.6.18.3 with RAID5
In-Reply-To: <bc36a6210702210745ha025453xd75f61e3bec416b1@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0702211744290.12039@yvahk01.tjqt.qr>
References: <bc36a6210702200930n2d4b1f76m9fc5e5f0728f7b48@mail.gmail.com> 
 <bc36a6210702201714nb18925ua8b89cd2c2ecad1@mail.gmail.com>
 <bc36a6210702210745ha025453xd75f61e3bec416b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Update: I think that you can ignore this error. I am getting
> segmentation faults when I attempt to rebuild the kernel. This is
> exactly the same problem I had with slackware 10.1 with the 2.6.10
> kernel. So I think it is a hardware issue. Memtest86 didn't show any
> errors after 35 passes, so I'll have to check the CPU and motherboard.

Googling for "iret exception: 0000" also reveals quite few
results (= one distinct), so this seems to be an issue that comes
up even less than now and then.


>> I was having instability with this machine before (slackware 10.1 with
>> 2.6.10 kernel) while compiling code (especially the kernel). I just
>> rebuilt is as a debian box. It never died in the raid array code
>> before though, just in gcc.

temperature problem?


Jan
-- 
