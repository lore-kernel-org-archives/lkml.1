Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYESJfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYESJfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYESJfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:35:37 -0400
Received: from h155.mvista.com ([63.81.120.155]:42139 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751555AbYESJfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:35:36 -0400
Message-ID: <483149E0.6010009@ru.mvista.com>
Date: Mon, 19 May 2008 13:35:28 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx
Subject: Re: [PATCH 1/9] Alchemy: export get_au1x00_speed for modules
References: <20080519080339.GA21985@roarinelk.homelinux.net> <20080519080416.GB21985@roarinelk.homelinux.net>
In-Reply-To: <20080519080416.GB21985@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Manuel Lauss wrote:
> From 8492076e98c7fd47c9dee53984dbd9568ace357d Mon Sep 17 00:00:00 2001
> From: Manuel Lauss <mlau@msc-ge.com>
> Date: Wed, 7 May 2008 13:42:55 +0200
> Subject: [PATCH] Alchemy: export get_au1x00_speed for modules
>
> au1xmmc.c driver depends on it, so export it for modules.
>
> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
>   

   I thought that has been merged.

WBR, Sergei


