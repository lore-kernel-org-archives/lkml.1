Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbXFIUzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbXFIUzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbXFIUzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:55:39 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:34463
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbXFIUzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:55:38 -0400
Message-ID: <466B2111.8020301@microgate.com>
Date: Sat, 09 Jun 2007 15:52:17 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Paul Fulghum <paulkf@microgate.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] tty restore locked ioctl file op
References: <1179098742.7322.5.camel@rousalka.dyndns.org> <1179396003.31796.4.camel@rousalka.dyndns.org> <20070517094557.c96f7e54.randy.dunlap@oracle.com> <1179421196.5000.5.camel@rousalka.dyndns.org> <1180206615.3430.8.camel@rousalka.dyndns.org> <20070608030629.GA18493@atjola.homenet> <1181315809.4811.5.camel@x2.microgate.com> <1181330448.5365.7.camel@amdx2.microgate.com> <20070608123350.5cc53c10.akpm@linux-foundation.org> <1181334857.3408.0.camel@x2.microgate.com> <20070609181805.GA2771@atjola.homenet>
In-Reply-To: <20070609181805.GA2771@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink wrote:
> Sorry for the delay, your mails didn't make it into my inbox, and I
> usually just mark threads on which I'm Cc'ed as read in my lkml mailbox,
> thus I didn't notice it earlier. Any traces of the lost mails on your
> side?

No clues on this end.

> The patch works as expected, no Oops in sight. Regarding the
> reproducability, it might be that it was easier to trigger on rc1. When
> I retried today with rc4, I only got 2 Oopses in a minute, while the
> first test had spitten out about 20 Oopses in 10 seconds (not sure if I
> really had rc1 running back then, though).

I'm sure it's very timing dependent.
I'm confident with this fix.

Thanks for your help.

--
Paul
