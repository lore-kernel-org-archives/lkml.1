Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYAIRrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYAIRrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 12:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYAIRqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 12:46:51 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:37060 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753361AbYAIRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:46:50 -0500
Message-ID: <478508BD.9030307@ru.mvista.com>
Date: Wed, 09 Jan 2008 20:47:41 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/15] ide: move wait_hwif_ready() documentation in the
 right place
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain> <20080104212439.6978.95269.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212439.6978.95269.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HNY. :-)

Bartlomiej Zolnierkiewicz wrote:

> * Move wait_hwif_ready() documentation before this function.

> * Fix trailing whitespaces.

> * s/wait-for-busy/wait-for-non-busy/

> * Remove no longer valid comment about the current code behavior.

> * Docbook-ize it.

> * Rename wait_hwif_ready() to ide_port_wait_ready().

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

MBR, Sergei
