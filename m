Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYHWLtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYHWLtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 07:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYHWLte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 07:49:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:31361 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752548AbYHWLte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 07:49:34 -0400
Message-ID: <48AFF946.4010201@ru.mvista.com>
Date: Sat, 23 Aug 2008 15:49:26 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/22] ide-floppy: add ide_floppy_set_media_lock() helper
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain> <20080810153555.16255.42725.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153555.16255.42725.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Add ide_floppy_set_media_lock() helper and convert idefloppy_open(),
> idefloppy_release() and ide_floppy_lockdoor() to use it.
>
> There should be no functional changes caused by this patch.
>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


