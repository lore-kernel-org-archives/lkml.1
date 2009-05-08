Return-Path: <linux-kernel-owner+w=401wt.eu-S1761849AbZEHWZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761849AbZEHWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZEHWZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:25:19 -0400
Received: from senator.holtmann.net ([87.106.208.187]:56973 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZEHWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:25:18 -0400
Subject: Re: Regression: Problem in using USB Bluetooth Dongle (Worked fine
 in  2.6.24.x)
From: Marcel Holtmann <marcel@holtmann.org>
To: Brian Marete <bgmarete@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6dd519ae0905080528j79640bb0l8fe475b2f09e6bc4@mail.gmail.com>
References: <6dd519ae0905080528j79640bb0l8fe475b2f09e6bc4@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 08 May 2009 15:24:58 -0700
Message-Id: <1241821498.4903.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

> At least until kernel version 2.6.24, I was able to use my USB
> bluetooth dongle to download contacts from my phone. I made a jump
> from 2.6.24 to 2.6.27, so I am not sure exactly which kernel version
> starts the problem, but all kernels from the latter (2.6.27) now do
> not work. The latest kernel I have tested is 2.6.29.2.

can you test 2.6.30-rc4 or bluetooth-testing.git. I am pretty sure that
whatever broke in 2.6.27 has been fixed by now. Some cheapo USB dongles
behaved wrongly and it was a long time not clear what caused it.

Regards

Marcel


