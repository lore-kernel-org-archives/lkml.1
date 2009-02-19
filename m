Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZBSAwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZBSAwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbZBSAwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:52:32 -0500
Received: from h155.mvista.com ([63.81.120.155]:2889 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751746AbZBSAwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:52:31 -0500
Message-ID: <499CAD45.9090600@ru.mvista.com>
Date: Thu, 19 Feb 2009 03:52:21 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH] ide-cd: minor ide_cdrom_setup() cleanup
References: <200902182019.33997.bzolnier@gmail.com>
In-Reply-To: <200902182019.33997.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Cache drive->queue in local variable and use max().
>
> There should be no functional changes caused by this patch.
>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


