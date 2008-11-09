Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYKIRTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYKIRTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 12:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYKIRTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 12:19:43 -0500
Received: from h155.mvista.com ([63.81.120.155]:32771 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755409AbYKIRTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 12:19:42 -0500
Message-ID: <49171BAD.9060306@ru.mvista.com>
Date: Sun, 09 Nov 2008 20:19:41 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] ide: push local_irq_{save,restore}() to do_identify()
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain> <20081109162331.18999.93299.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162331.18999.93299.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Push local_irq_{save,restore}() from actual_try_to_identify()
> to do_identify() and remove no longer needed local_irq_enable().

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
