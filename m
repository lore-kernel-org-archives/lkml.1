Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXELT7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXELT7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbXELT6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:58:52 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:55891 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbXELT6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:58:51 -0400
Message-ID: <46461C77.5040404@simon.arlott.org.uk>
Date: Sat, 12 May 2007 20:58:47 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: default y idiocy
References: <20070512182343.GO4629@kernel.dk>
In-Reply-To: <20070512182343.GO4629@kernel.dk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/07 19:23, Jens Axboe wrote:
> Hi,
> 
> This has bothered me for a long time, and it just seems to be getting
> worse. Can people please STOP defaulting non-essential stuff to 'y'?
> Grrr.

Is there a reason why various 10/100/1000Mbit network cards are 'y' too?
There's even a default SCSI 'm' that seems to be completely hidden from 
the menu too (CONFIG_SCSI_WAIT_SCAN). It depends on SCSI but I can't 
disable SCSI...

-- 
Simon Arlott
