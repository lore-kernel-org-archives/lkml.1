Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYFUTiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYFUTiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYFUTiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:38:10 -0400
Received: from homer.mvista.com ([63.81.120.155]:65188 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703AbYFUTiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:38:09 -0400
Message-ID: <485D589B.5030105@ru.mvista.com>
Date: Sat, 21 Jun 2008 23:38:03 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: filter out invalid transfer mode values in set_xfer_rate()
References: <200806212120.41514.bzolnier@gmail.com>
In-Reply-To: <200806212120.41514.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> Filter out invalid transfer mode values (0x02-0x07) in write handler
> for obsoleted /proc/ide/hd?/settings:current_speed setting.
>
> While at it:
>
> * Use XFER_UDMA_6 define.
>
> Suggested-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Sergei, IIRC that it is what you were suggesting some time ago.
>   

   Maybe I did. :-) But I don't see what that gives to us now...

WBR, Sergei


