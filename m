Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYAVQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYAVQjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYAVQjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:39:02 -0500
Received: from h155.mvista.com ([63.81.120.155]:59772 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750823AbYAVQjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:39:00 -0500
Message-ID: <47961C57.3080009@ru.mvista.com>
Date: Tue, 22 Jan 2008 19:39:51 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] ide: remove ide_auto_reduce_xfer()
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain> <20080121233219.30311.13119.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233219.30311.13119.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> While at it:

> * Remove needless '!drive->crc_count' check.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

