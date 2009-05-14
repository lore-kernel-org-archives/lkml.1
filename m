Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbZENNDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbZENNDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbZENNDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:03:31 -0400
Received: from h155.mvista.com ([63.81.120.155]:4742 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757790AbZENNDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:03:30 -0400
Message-ID: <4A0C16C9.10508@ru.mvista.com>
Date: Thu, 14 May 2009 17:04:09 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] ide: replace special_t typedef by IDE_SFLAG_* flags
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain> <20090513205207.28638.44663.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205207.28638.44663.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Replace:
> - special_t typedef by IDE_SFLAG_* flags
> - 'special_t special' ide_drive_t's field by 'u8 special_flags' one

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

WBR, Sergei
