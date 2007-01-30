Return-Path: <linux-kernel-owner+w=401wt.eu-S965251AbXA3E40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965251AbXA3E40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 23:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965261AbXA3E40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 23:56:26 -0500
Received: from mailout1.vmware.com ([65.113.40.130]:35175 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965251AbXA3E4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 23:56:25 -0500
Message-ID: <45BECFF8.7070605@vmware.com>
Date: Mon, 29 Jan 2007 20:56:24 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] vmi: cleanups
References: <20070127234928.64d8e437.akpm@osdl.org> <20070130011145.GA3754@stusta.de>
In-Reply-To: <20070130011145.GA3754@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the following cleanups:
> - make needlessly global code static
> - remove pointless fastcall annotations
> - don't mark functions in C files as inline
> - #if 0 the following unused function:
>   - arch/i386/kernel/vmitime.c: read_stolen_cycles()
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>   

Acked-by: Zachary Amsden <zach@vmware.com>

Thanks Adrian!  I have some more bugfix / cleanup patches queued up, but 
somehow I think you magically avoided creating conflicts with them.

Zach
