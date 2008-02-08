Return-Path: <linux-kernel-owner+w=401wt.eu-S1763716AbYBHRVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763716AbYBHRVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935627AbYBHRSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:18:06 -0500
Received: from homer.mvista.com ([63.81.120.155]:60844 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935193AbYBHRSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:18:04 -0500
Message-ID: <47AC8EFC.8030506@ru.mvista.com>
Date: Fri, 08 Feb 2008 20:18:52 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] ide: factor out cable detection from ide_init_port()
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <20080208004455.17746.44570.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004455.17746.44570.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Factor out cable detection from ide_init_port() to ide_port_cable_detect().

> * Move ide_port_cable_detect() call to ide_device_add_all().

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
