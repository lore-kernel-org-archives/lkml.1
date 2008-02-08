Return-Path: <linux-kernel-owner+w=401wt.eu-S1763936AbYBHRVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763936AbYBHRVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935786AbYBHRTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:19:52 -0500
Received: from homer.mvista.com ([63.81.120.155]:60863 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935778AbYBHRTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:19:50 -0500
Message-ID: <47AC8F6A.8040900@ru.mvista.com>
Date: Fri, 08 Feb 2008 20:20:42 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/18] ide: move ide_port_setup_devices() call to ide_device_add_all()
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <20080208004516.17746.18498.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004516.17746.18498.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Add ide_cfg_mtx lock/unlock to ide_port_setup_devices() and then move
> ide_port_setup_devices() call from init_irq() to ide_device_add_all().

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
