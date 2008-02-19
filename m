Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYBSMMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYBSMMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYBSMMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:12:19 -0500
Received: from homer.mvista.com ([63.81.120.155]:3973 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752661AbYBSMMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:12:17 -0500
Message-ID: <47BAC7DE.70307@ru.mvista.com>
Date: Tue, 19 Feb 2008 15:13:18 +0300
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
