Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYBRPr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYBRPr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYBRPru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:47:50 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:54096 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752629AbYBRPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:47:49 -0500
Message-ID: <47B9A8E3.7050009@ru.mvista.com>
Date: Mon, 18 Feb 2008 18:48:51 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ide: fix sparse warning about shadowing 'flags' symbol
References: <200802172052.10691.bzolnier@gmail.com>
In-Reply-To: <200802172052.10691.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> drivers/ide/ide.c:801:18: warning: symbol 'flags' shadows an earlier one
> drivers/ide/ide.c:732:16: originally declared here

> Also fix some whitespace damage while at it.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

