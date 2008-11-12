Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYKLWtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYKLWtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYKLWs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:48:59 -0500
Received: from h155.mvista.com ([63.81.120.155]:4168 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752973AbYKLWs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:48:58 -0500
Message-ID: <491B5D53.9000308@ru.mvista.com>
Date: Thu, 13 Nov 2008 01:48:51 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 1/6] tx493x: fix intendation
References: <200811122214.13396.bzolnier@gmail.com>
In-Reply-To: <200811122214.13396.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Trivial CodingStyle fixup for tx4938ide and tx4939ide drivers.
>   

   I didn't know CodingStyle covers the field initializers. Anyway, I'm 
sure you meant "indentation". :-P

> CC: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtyltov <sshtylyov@ru.mvista.com>

MBR, Sergei


