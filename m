Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXEIWFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXEIWFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbXEIWFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:05:04 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:36627
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbXEIWFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:05:03 -0400
Message-ID: <46425300.7060507@microgate.com>
Date: Wed, 09 May 2007 17:02:24 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use tty_schedule in VT code.
References: <Pine.LNX.4.64.0705082107460.3459@pentafluge.infradead.org> <1178656361.14867.7.camel@x2.microgate.com> <464235F4.6080006@microgate.com> <Pine.LNX.4.64.0705092154290.20229@pentafluge.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0705092154290.20229@pentafluge.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Simmons wrote:
> Great!!!! Here is the patch updated with the delay value set to zero.

Acked-by: Paul Fulghum <paulkf@microgate.com>

You should submit this to
Andrew Morton <akpm@linux-foundation.org>
so it can get into the mm tree.

--
Paul

