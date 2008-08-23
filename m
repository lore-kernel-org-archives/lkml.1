Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYHWV6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYHWV6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 17:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYHWV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 17:58:35 -0400
Received: from h155.mvista.com ([63.81.120.155]:35153 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753124AbYHWV6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 17:58:35 -0400
Message-ID: <48B08804.7070705@ru.mvista.com>
Date: Sun, 24 Aug 2008 01:58:28 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/22] ide: add ide_queue_pc_tail() helper
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain> <20080810153623.16255.96138.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153623.16255.96138.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Add ide_queue_pc_tail() and convert ide-{floppy,tape}.c to use it
>   instead of ide*_queue_pc_tail().
>
> * Remove no longer used ide*_queue_pc_tail().
>
> There should be no functional changes caused by this patch.
>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


