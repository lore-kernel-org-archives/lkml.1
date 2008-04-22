Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbYDVQJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbYDVQJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYDVQJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:09:50 -0400
Received: from h155.mvista.com ([63.81.120.155]:31567 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753758AbYDVQJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:09:49 -0400
Message-ID: <480E0DA8.20306@ru.mvista.com>
Date: Tue, 22 Apr 2008 20:09:12 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ide: skip "VLB sync" if host uses MMIO
References: <200804122103.51449.bzolnier@gmail.com>
In-Reply-To: <200804122103.51449.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Skip "VLB sync" in ata_{in,out}put_data() if host uses MMIO.

> * Use I/O ops directly in ata_vlb_sync() an drop no longer needed
>   'ide_drive_t *drive' argument.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
