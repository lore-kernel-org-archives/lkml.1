Return-Path: <linux-kernel-owner+w=401wt.eu-S1765494AbXJRMAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765494AbXJRMAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762680AbXJRL7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:59:51 -0400
Received: from h155.mvista.com ([63.81.120.155]:42682 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755952AbXJRL7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:59:50 -0400
Message-ID: <47174AC1.7080800@ru.mvista.com>
Date: Thu, 18 Oct 2007 16:00:01 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux IDE <linux-ide@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/3] ide: Add ide_get_paired_drive() helper
References: <20071018005621.8F637DDEB8@ozlabs.org>
In-Reply-To: <20071018005621.8F637DDEB8@ozlabs.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:

> This adds a helper to get to the "other" drive on a pair connected
> to a given hwif.

    Maibe "mate drive" would've been a better name that "paired"...

> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
