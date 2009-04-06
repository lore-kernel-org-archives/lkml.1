Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZDFQWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZDFQWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZDFQWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:22:09 -0400
Received: from h155.mvista.com ([63.81.120.155]:14132 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750804AbZDFQWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:22:07 -0400
Message-ID: <49DA2C50.6000108@ru.mvista.com>
Date: Mon, 06 Apr 2009 20:22:40 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tx493[89]ide: Remove big endian version of tx493[89]ide_tf_{load,read}
References: <1239034146-3514-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1239034146-3514-1-git-send-email-anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:

> Now tx493[89]ide_tf_{load,read} do not contain word I/O operations.
> They are endian-free now.

> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

    Oops, now this clashes with my patchset (not applied to pata-2.6 AFAICS). 
I guess I'll have to repost it... Bart?

MBR, Sergei
