Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYKIRQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYKIRQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 12:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYKIRQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 12:16:01 -0500
Received: from h155.mvista.com ([63.81.120.155]:32762 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755450AbYKIRQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 12:16:00 -0500
Message-ID: <49171ACF.4020702@ru.mvista.com>
Date: Sun, 09 Nov 2008 20:15:59 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] ide: remove dead code from drive_is_ready()
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain> <20081109162233.18999.12402.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162233.18999.12402.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> We guarantee 400ns delay at the time of issuing the command.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
