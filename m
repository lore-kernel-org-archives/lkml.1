Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbYD2TG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbYD2TG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYD2TGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:06:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46146 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYD2TGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:06:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481771B8.9070105@s5r6.in-berlin.de>
Date: Tue, 29 Apr 2008 21:06:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4 usage statistics
References: <20080428202433.GA13417@hera.kernel.org> <20080428205631.GA2813@cs181133002.pp.htv.fi> <20080428211812.GA19093@1wt.eu>
In-Reply-To: <20080428211812.GA19093@1wt.eu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Speaking for my case, at Exosec we still use 2.4 a lot. Main reason is that
> we are used to apply a lot of patches. [...]  I have already thought about
> moving to 2.6.16, but I would have had to port my patches, [...]
> Since I would have gained nothing in this operation, it
> was easier to stick to 2.4.
> 
> I'm waiting for other people's excuses now :-)

A variation of the theme, which I as maintainer of some drivers in 2.6 
heard by way of occasional questions on subsystem mailinglists or 
off-list:  Kernel customizations for embedded systems in combination 
with a custom userland.  Moving all this software over to 2.6 was not 
considered worth the effort.

Another reason which I read here and there and don't know how real the 
issue is:  2.6's minimum possible footprint is said to be unable to 
compete with 2.4 for really resource restricted applications.

Could it actually be that 2.4 outnumbers 2.6 in embedded installations?

(I don't work with 2.4 myself and I don't know the domain of embedded 
systems.)
-- 
Stefan Richter
-=====-==--- -=-- ===-=
http://arcgraph.de/sr/
