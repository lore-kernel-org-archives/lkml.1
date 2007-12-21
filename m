Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbXLUMB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbXLUMB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXLUMBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:01:19 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:30229 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751091AbXLUMBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:01:18 -0500
Message-ID: <476BAB23.70503@ru.mvista.com>
Date: Fri, 21 Dec 2007 15:01:39 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/63] ide-cd: fix 'ireason' reporting in cdrom_pc_intr()
References: <200712200158.32631.bzolnier@gmail.com>
In-Reply-To: <200712200158.32631.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Mask 'ireason' variable so only the valid interrupt reason bits
> will be reported on "drive appears confused" error.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
