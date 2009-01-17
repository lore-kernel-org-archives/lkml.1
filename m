Return-Path: <linux-kernel-owner+w=401wt.eu-S1765361AbZAQUNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765361AbZAQUNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZAQUN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:13:28 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:10777 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389AbZAQUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:13:27 -0500
Message-ID: <49723BE1.2050105@ru.mvista.com>
Date: Sat, 17 Jan 2009 23:13:21 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] ide: remove ide_do_drive_cmd()
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain> <20090115200108.17294.11783.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200108.17294.11783.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Use elv_add_request() instead of __elv_add_request() in ide_do_drive_cmd().
>
> * ide_do_drive_cmd() is used only in ide-{atapi,cd}.c so inline it there.
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


