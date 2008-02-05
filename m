Return-Path: <linux-kernel-owner+w=401wt.eu-S1762787AbYBEW1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787AbYBEW1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762232AbYBEW1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:27:36 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:57498
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762164AbYBEW1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:27:34 -0500
Message-ID: <47A8E2D5.6010503@microgate.com>
Date: Tue, 05 Feb 2008 16:27:33 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Rick Warner <rick@microway.com>, linux-kernel@vger.kernel.org
Subject: Re: serial port regression caused by "Char: tty_ioctl, use wait_event_interruptible_timeout"
 patch
References: <200802051402.26816.rick@microway.com> <47A8C4AB.3030301@microgate.com> <47A8CCC0.8020703@microgate.com> <200802051632.54058.rick@microway.com> <47A8D71F.4050601@microgate.com> <47A8DC2B.20604@gmail.com>
In-Reply-To: <47A8DC2B.20604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> It should be fixed already as of
> git-describe db99247a
> v2.6.24-rc6-95-gdb99247
> 
> So since 2.6.24-rc7.
> 
> Maybe we should consider the fix for 2.6.23 too.

Whoops, I missed that.
Problem solved :-)

Thanks,
Paul
