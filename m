Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbYDSQ62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbYDSQ62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYDSQ6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:58:18 -0400
Received: from h155.mvista.com ([63.81.120.155]:22904 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751150AbYDSQ6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:58:18 -0400
Message-ID: <480A2481.40507@ru.mvista.com>
Date: Sat, 19 Apr 2008 20:57:37 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] siimage: remove proc_reports_siimage()
References: <200804092052.41806.bzolnier@gmail.com>
In-Reply-To: <200804092052.41806.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * proc_reports_siimage() is now only called by init_chipset_siimage()
>   so inline it there.

> * Use array instead of switch statement for reporting clock modes.

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
