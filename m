Return-Path: <linux-kernel-owner+w=401wt.eu-S1764962AbYBTSSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764962AbYBTSSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYBTSSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:18:22 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:46182 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbYBTSSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:18:21 -0500
Message-ID: <47BC6EEC.4020000@s5r6.in-berlin.de>
Date: Wed, 20 Feb 2008 19:18:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-rc2: ohci1394 problem
References: <47BBDB07.80409@m3y3r.de> <47BBF771.40203@s5r6.in-berlin.de> <47BC6918.4000203@m3y3r.de> <47BC6E42.10409@s5r6.in-berlin.de>
In-Reply-To: <47BC6E42.10409@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>>> Thomas Meyer wrote at LKML:
>>>> With 2.6.25-rc2 my kernel log consists mainly of:
>>>>
>>>> "ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
> 
> There are junk interrupt events sent to ohci1394's IRQ handler.

PS, do you still have the log lines which come from ohci1394's
initialization?
-- 
Stefan Richter
-=====-==--- --=- =-=--
http://arcgraph.de/sr/
