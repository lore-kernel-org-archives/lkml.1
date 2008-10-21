Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYJURL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYJURL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYJURLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:11:18 -0400
Received: from xenotime.net ([66.160.160.81]:49317 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751032AbYJURLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:11:17 -0400
Message-ID: <48FE0D32.9090103@xenotime.net>
Date: Tue, 21 Oct 2008 10:11:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: vanilla tree not compiling
References: <200810211855.00182.oliver@neukum.org>
In-Reply-To: <200810211855.00182.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Hi,
>
> compilation failed with this error:
>
> ERROR: "p9_debug_level" [net/9p/9pnet.ko] undefined!
> WARNING: modpost: Found 4 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Fehler 1
> make: *** [modules] Fehler 2
>
> The last commit was 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4
> .config is attached.
>   
Hi Oliver,
Patches have been posted for this a few times.

~Randy

