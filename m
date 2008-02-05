Return-Path: <linux-kernel-owner+w=401wt.eu-S1761989AbYBEVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761989AbYBEVih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761503AbYBEVhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:37:39 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:44694
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760534AbYBEVhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:37:37 -0500
Message-ID: <47A8D71F.4050601@microgate.com>
Date: Tue, 05 Feb 2008 15:37:35 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Rick Warner <rick@microway.com>
CC: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: serial port regression caused by "Char: tty_ioctl, use wait_event_interruptible_timeout"
 patch
References: <200802051402.26816.rick@microway.com> <47A8C4AB.3030301@microgate.com> <47A8CCC0.8020703@microgate.com> <200802051632.54058.rick@microway.com>
In-Reply-To: <200802051632.54058.rick@microway.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Warner wrote:
> This modification solved my problem.  Will this change go into mainline, or 
> will we need to maintain our own branch of the kernel to keep this working?

It should be accepted into mainline as it restores
the original behavior. I'll put together a patch
submission tomorrow unless Jiri beats me to it.

Thanks,
Paul

-- 
Paul Fulghum
Microgate Systems, Ltd.
