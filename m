Return-Path: <linux-kernel-owner+w=401wt.eu-S1765487AbYESNjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765487AbYESNjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763424AbYESN1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:27:33 -0400
Received: from h155.mvista.com ([63.81.120.155]:45009 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763413AbYESN1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:27:32 -0400
Message-ID: <4831802B.7060409@ru.mvista.com>
Date: Mon, 19 May 2008 17:27:07 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx
Subject: Re: [PATCH 9/9] au1xmmc: Add back PB1200/DB1200 MMC activity LED
 support
References: <20080519080339.GA21985@roarinelk.homelinux.net> <20080519080837.GJ21985@roarinelk.homelinux.net>
In-Reply-To: <20080519080837.GJ21985@roarinelk.homelinux.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Manuel Lauss wrote:

> Add back PB1200/DB1200 MMC activity LED support just the way
> it was done in the original driver source.

> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>

   For the reason of "bisectability" you'd better merge this with patch 3.

WBR, Sergei
