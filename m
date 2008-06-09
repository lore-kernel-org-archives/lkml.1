Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYFIMCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYFIMCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbYFIMCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:02:40 -0400
Received: from waikiki.ops.eusc.inter.net ([84.23.254.155]:51397 "EHLO
	waikiki.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757572AbYFIMCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:02:21 -0400
X-Greylist: delayed 1180 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 08:02:21 EDT
X-Trace: 4d7c73656261737469616e2e6b6c6f736b6140736e6166752e64657c38352e3137
	382e37372e3230357c314b35666c6e2d3030304d4e772d36327c31323133303131
	373539
Message-ID: <484D172E.7080405@snafu.de>
Date: Mon, 09 Jun 2008 13:42:38 +0200
From: Oncaphillis <oncaphillis@snafu.de>
Reply-To: oncaphillis@snafu.de
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: vesafb@1280x1024 used to work for me in 2.4.x
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a 1600x1024 LCD panel with a nvidia
GeForce 7600 graphic card. Up until recently I used
a 2.4.xx kernel and could happily convince it to use
the vesafb at 1280x1024 res in vertical mode by
adding "vga=775 fbcfbcon=rotate:3" as a kernel arg.

This stopped to work for me since 2.5.x. The vesafb prompts
me for some dull resolutions (like 80x60 etc).

Note that 775 never showed up as a supported vesa mode.
If I supplied any bogus vesa mode (e.g. vga=999999) the
2.4.x vesafb driver also only offered me the dull resolutions. But
explicitly setting it to 775 worked.

Thank you very much indeed

O.
