Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZEQLPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZEQLPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 07:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZEQLPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 07:15:42 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:41449 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZEQLPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 07:15:41 -0400
Date: Sun, 17 May 2009 13:15:35 +0200
From: Martin Lottermoser <Martin.Lottermoser@t-online.de>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090517111535.GA8175@wanza.invalid>
References: <20090517091224.GA8280@wanza.invalid> <20090517104228.GA28605@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090517104228.GA28605@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ID: VrjYR2ZlYh5Pqt55JUMvXbynOK9orpnXf+uUQSJK2djnYJ06OT8GIqeFRKwSXsxgnY
X-TOI-MSGID: 90189195-b2cb-4c64-baa3-ad7855181b6f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 17, 2009 at 12:42:28PM +0200, Borislav Petkov wrote:
...
> can you catch that kernel panic on another machine through serial
> console/netconsole and send it to me, please?

no, I don't have the necessary cable for that, but I'll provide a
photograph of the screen and put it on my web site. For now, as I see
from my notes, the call trace was:

  Call Trace:
    handle_IRQ_event
    handle_edge_IRQ
    do_IRQ
    __dequeue_entity
    common_interrupt
    default_idle
    cpu_idle
    rest_init

Thanks for the interest,
Martin Lottermoser
-- 
Martin Lottermoser             Martin.Lottermoser at _REMOVE_t-online.de
Greifswaldstrasse 28
38124 Braunschweig             http://home.vrweb.de/martin.lottermoser
Germany
