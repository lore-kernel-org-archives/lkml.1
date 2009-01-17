Return-Path: <linux-kernel-owner+w=401wt.eu-S932373AbZAQUXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbZAQUXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbZAQUW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:22:56 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:10886 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754775AbZAQUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:22:54 -0500
Message-ID: <49723E18.5030006@ru.mvista.com>
Date: Sat, 17 Jan 2009 23:22:48 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] ide: move drive_is_ready() to ide-io.c
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain> <20090115200053.17294.47740.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200053.17294.47740.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Move drive_is_ready() to ide-io.c, then make it static.
>
> Also make some minor CodingStyle fixups while at it.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


