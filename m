Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292Ab0AGWB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0AGWB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283Ab0AGWBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:01:08 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:17876 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754279Ab0AGWBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:01:02 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALPoRUtbst05/2dsb2JhbADUUwqEJQQ
Date: Thu, 7 Jan 2010 23:01:00 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] watchdog/ixp2000: Fix build failure caused by missing
	include
Message-ID: <20100107220100.GM3122@infomag.iguana.be>
References: <201001070335.49710.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001070335.49710.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Thu, 7 Jan 2010 03:24:28 +0100
> 
> This patch fixes a build failure[1] caused by the missing include of
> timer.h and thus fixes the build failure.
> 
> Notably the build failure existed since October 2009! [2]
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/1983339/
> [2] http://kisskb.ellerman.id.au/kisskb/buildresult/1351737/
> 
> Patch against Linus' tree
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Patch added to linux-2.6-watchog-next tree.

Kind regards,
Wim.

