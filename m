Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbXLUMdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbXLUMdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbXLUMd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:33:27 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:30574 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750920AbXLUMd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:33:26 -0500
Message-ID: <476BB2AB.60605@ru.mvista.com>
Date: Fri, 21 Dec 2007 15:33:47 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/63] ide-cd: remove struct atapi_{mechstat_header,changer_info,slot}
References: <200712200209.24164.bzolnier@gmail.com>
In-Reply-To: <200712200209.24164.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Remove ->changer_info from struct cdrom_info (it is never allocated).

> * Remove unused struct atapi_{mechstat_header,changer_info,slot}.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

