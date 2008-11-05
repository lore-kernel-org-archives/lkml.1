Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYKEQf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYKEQf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYKEQfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:35:52 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:17168 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYKEQfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:35:51 -0500
Message-ID: <4911CB47.6030809@oracle.com>
Date: Wed, 05 Nov 2008 08:35:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: make htmldocs errors
References: <804dabb00811050825td613b25lf400f4963e83e78c@mail.gmail.com>
In-Reply-To: <804dabb00811050825td613b25lf400f4963e83e78c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh wrote:
> This is on the latest linus tree (75fa67706cce5272bcfc51ed646f2da21f3bdb6e):
> 
> /mnt/hd0/download/linux-2.6-latest>make htmldocs
> make[1]: *** No rule to make target `include/asm-x86/io_32.h', needed
> by `Documentation/DocBook/deviceiobook.xml'.  Stop.
> make: *** [htmldocs] Error 2

Hi,
I thought that I had already fixed that, but I'll take another look
at it.

Thanks,
-- 
~Randy
