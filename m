Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYCIUOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYCIUOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYCIUOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:14:35 -0400
Received: from h155.mvista.com ([63.81.120.155]:36954 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752613AbYCIUOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:14:34 -0400
Message-ID: <47D44576.7010807@ru.mvista.com>
Date: Sun, 09 Mar 2008 23:15:50 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] ide: move ide_setup_dma() call out from ->init_dma
 method
References: <200803082231.57531.bzolnier@gmail.com>
In-Reply-To: <200803082231.57531.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
