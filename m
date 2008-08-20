Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYHTKEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYHTKEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYHTKE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:04:26 -0400
Received: from h155.mvista.com ([63.81.120.155]:29183 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751811AbYHTKEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:04:25 -0400
Message-ID: <48ABEC23.6070401@ru.mvista.com>
Date: Wed, 20 Aug 2008 14:04:19 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] ide-disk: add ide_do_setfeature() helper
References: <20080817171454.27943.37234.sendpatchset@localhost.localdomain> <20080817171514.27943.66688.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817171514.27943.66688.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Add ide_do_setfeature() helper and convert set_{wcache,acoustic}()
> to use it.
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


