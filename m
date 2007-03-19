Return-Path: <linux-kernel-owner+w=401wt.eu-S1030352AbXCSQeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030352AbXCSQeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030354AbXCSQeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:34:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35160 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030352AbXCSQeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:34:20 -0400
Date: Mon, 19 Mar 2007 17:34:23 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Zilvinas Valinskas <zilvinas@wilibox.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Oops in  pl2303_shutdown()
Message-ID: <20070319163423.GV752@stusta.de>
References: <1174318078.4601.77.camel@zv.wilibox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1174318078.4601.77.camel@zv.wilibox.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 05:27:58PM +0200, Zilvinas Valinskas wrote:
> Hello, 
> 
> Before 2.6.21-rc4 (vanilla) serial was oopsing if I pull usb-serial
> cable while minicom was running. Now it doesn't matter if minicom is
> running or minicom closed, pulling serial cable results in such oops.
>...

Does the patch from [1] fix it?

cu
Adrian

[1] http://lkml.org/lkml/2007/3/13/217

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

