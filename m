Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbXISQdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbXISQdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbXISQdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:33:23 -0400
Received: from baikonur.stro.at ([213.239.196.228]:2928 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbXISQdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:33:22 -0400
Date: Wed, 19 Sep 2007 18:33:18 +0200
From: maximilian attems <max@stro.at>
To: Michael Chan <mchan@broadcom.com>
Cc: David Miller <davem@davemloft.net>, vda.linux@googlemail.com,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: bnx2 dirver's firmware images
Message-ID: <20070919163318.GG6618@stro.at>
References: <200709181823.26429.vda.linux@googlemail.com> <1190141114.9540.216.camel@dell> <20070918.112337.74737433.davem@davemloft.net> <1190145951.9540.230.camel@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190145951.9540.230.camel@dell>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Michael Chan wrote:

> The bnx2 firmware changes quite frequently.  A new driver quite often
> requires new firmware to work correctly.  Splitting them up makes things
> difficult for the user.

sorry didn't check, what's the license of the firmware?
 
> The firmware in tg3 is a lot more mature and I don't expect it to
> change.  I think tg3 is better suited for using request_firmware().

well thanks that would help us a lot,
we have to strip the firmware for Debian for the upcoming Lenny release.
as the shipping exception for the previous 2 releases will not be granted
again. so a separate firmware would be great. also afaik only some boards
need it. it is a pressing need for us as tg3 with stripped firmware of
course doesn't build.

-- 
maks
