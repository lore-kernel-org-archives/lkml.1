Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbXFDPM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbXFDPM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbXFDPMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:12:08 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:37711 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbXFDPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:12:07 -0400
Message-ID: <46642B0C.6070003@gmail.com>
Date: Mon, 04 Jun 2007 17:09:00 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jens Axboe <axboe@suse.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Q] Bio traversal trouble?
References: <4663DE68.5030200@gmail.com> <46642AB3.1000907@gmail.com>
In-Reply-To: <46642AB3.1000907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2007 05:07 PM, Rene Herman wrote:

>> Call Trace:
>>  [<c486504d>] __mitsumi_get_frame+0xc/0x16 [mitsumi]
>>  [<c4865ab7>] mitsumi_get_frame+0x120/0x134 [mitsumi]
>>  [<c1015f7b>] lock_timer_base+0x15/0x2f
>>  [<c10a0531>] cfq_set_request+0x0/0x144
> 
> Perhaps interesting (and perhaps not) -- I've been unable to reproduce 
> the OOPS after rebooting with elevator=as.

Kernel is vanilla 2.6.21.3.

Rene.

