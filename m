Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbYLaQY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbYLaQY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYLaQYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:24:47 -0500
Received: from ganymede.lunarpages.com ([216.97.232.250]:33492 "EHLO
	ganymede.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbYLaQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:24:47 -0500
Message-ID: <495B9CC9.5080507@kcore.org>
Date: Wed, 31 Dec 2008 17:24:41 +0100
From: Jan De Luyck <ml_linuxkernel_20080830@kcore.org>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28 - cannot find root fs on Acer TM 291 (ICH4-M)
References: <495B5ABD.7040909@kcore.org> <18779.24723.646720.252479@harpo.it.uu.se>
In-Reply-To: <18779.24723.646720.252479@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ganymede.lunarpages.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kcore.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:

> 
> You need to enable IDE_GD and IDE_GD_ATA.
> 
> But I recommend that you switch to libata instead (with ata_piix driver).

Grmpf. I have no idea why I didn't tag that one. I guess the ATAPI in the
description somehow made me think it was for ATAPI devices only, not ATA.

Thanks for the pointer.

Are there any real benefits to switching to libata? Except ofcourse, more
uptodate, being actively developed on, ... ;)

Kind regards

Jan
