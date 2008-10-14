Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbYJNSyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbYJNSyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYJNSyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:54:13 -0400
Received: from h155.mvista.com ([63.81.120.155]:3349 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751859AbYJNSyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:54:12 -0400
Message-ID: <48F4EAC4.4000702@ru.mvista.com>
Date: Tue, 14 Oct 2008 22:53:56 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] ide: remove dead <asm-arm/arch-sa1100/ide.h>
References: <200808101745.20434.bzolnier@gmail.com>
In-Reply-To: <200808101745.20434.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> It has been dead for more than 3 years and needs to be converted
> to use platform PATA support anyway.

    This patch in the current pata-2.6 series does not apply at all.

> Cc: Russell King <rmk@arm.linux.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applying patch ide-remove-dead-asm-arm-arch-sa1100-ide-h.patch
The text leading up to this was:
--------------------------
|From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
|Subject: [PATCH] ide: remove dead <asm-arm/arch-sa1100/ide.h>
|
|It has been dead for more than 3 years and needs to be converted
|to use platform PATA support anyway.
|
|Cc: Russell King <rmk@arm.linux.org.uk>
|Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
|---
| include/asm-arm/arch-sa1100/ide.h |   75 --------------------------------------
| 1 file changed, 75 deletions(-)
|
|Index: b/include/asm-arm/arch-sa1100/ide.h
|===================================================================
|--- a/include/asm-arm/arch-sa1100/ide.h
|+++ /dev/null
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored

MBR, Sergei
