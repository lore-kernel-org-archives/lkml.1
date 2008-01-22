Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbYAVOJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbYAVOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYAVOJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:09:49 -0500
Received: from h155.mvista.com ([63.81.120.155]:58434 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751977AbYAVOJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:09:48 -0500
Message-ID: <4795F95F.9020708@ru.mvista.com>
Date: Tue, 22 Jan 2008 17:10:39 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/16] ide: remove ->nice0 and ->nice2 fields from ide_drive_t
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain> <20080121233130.30311.83202.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233130.30311.83202.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * ->nice0 and ->nice2 ide_drive_t fields are always zero so remove them.

> * IDE_NICE_0 and IDE_NICE_2 defines from <linux/hdreg.h> are no longer
>   used by any kernel code so cover them with #ifndef/#endif __KERNEL__.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
