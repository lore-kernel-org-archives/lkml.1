Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbZK3TAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbZK3TAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:00:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZK3TAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:00:03 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:49294 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752815AbZK3TAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:00:01 -0500
Message-ID: <4B141670.10906@ru.mvista.com>
Date: Mon, 30 Nov 2009 22:01:04 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] slc90e66: fix UDMA handling
References: <200911301955.18158.bzolnier@gmail.com>
In-Reply-To: <200911301955.18158.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Fix checking of the currently programmed UDMA mode.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
