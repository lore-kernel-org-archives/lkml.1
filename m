Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbZGGAay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbZGGAay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbZGGATA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:19:00 -0400
Received: from fall-lakeland.atl.sa.earthlink.net ([207.69.195.103]:45440 "EHLO
	fall-lakeland.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757467AbZGGAS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:18:59 -0400
X-Greylist: delayed 675 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 20:18:59 EDT
Message-ID: <4A5291CC.8080809@earthlink.net>
Date: Mon, 06 Jul 2009 20:07:40 -0400
From: Robert Reif <reif@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15 (Ubuntu-1.1.15+nobinonly-0ubuntu2)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] sparc: use asm-generic/dma-mapping-common.h and pci-dma-compat.h
References: <1246860820-20629-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1246860820-20629-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> The patchset is only compile-tested (sorry about it).
>   
Boot tested on sparc32 SparcStation 20.

Tested-by: Robert Reif <reif@earthlink.net>
