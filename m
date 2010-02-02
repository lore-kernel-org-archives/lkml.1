Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0BBG6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:58:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44231 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab0BBG6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:58:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B67CCEC.2030103@s5r6.in-berlin.de>
Date: Tue, 02 Feb 2010 07:57:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug #14487] PANIC:
 early exception 08 rip 246:10 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com> <4B67CC55.40301@s5r6.in-berlin.de>
In-Reply-To: <4B67CC55.40301@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Do I understand correctly that at this moment it is only known that the
> bug could be
>   - *either* a 2.6.31 -> 2.6.32 regression
>   - *or* an x86-64 specific bug that does not occur on x86-32,
> right?

(OK, according to your other post it /is/ a regression, at least on
x86-64 and definitely between 2.6.27 (good) and 2.6.32 (bad).)
-- 
Stefan Richter
-=====-==-=- --=- ---=-
http://arcgraph.de/sr/
