Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYL2NZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYL2NZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYL2NZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:25:15 -0500
Received: from pih-relay06.plus.net ([212.159.14.19]:58076 "EHLO
	pih-relay06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbYL2NZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:25:14 -0500
X-Greylist: delayed 1519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 08:25:14 EST
Message-ID: <4958C9CD.5050003@yahoo.com>
Date: Mon, 29 Dec 2008 12:59:57 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: for.poige+linux@gmail.com
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: > I even didn't have a backtrace.
References: <fa.q3E31Fk9IOYkDJ38/mQp9Iyp2TI@ifi.uio.no> <fa.qMGHzuTz1nuoHKywmH/aLmriclo@ifi.uio.no> <fa.LbTTdeLVGfaCxioVgNMO13Libio@ifi.uio.no>
In-Reply-To: <fa.LbTTdeLVGfaCxioVgNMO13Libio@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: dcbf12887fb17869f7f24121bf3b4486
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Podlesny wrote:
> 	Similar, but no exactly. I just thought that unlikely BIOS erases
> memory content during "fast checks", so kernel diagnostic could be

My understanding is that the only part of the BIOS that doesn't get 
cleared over a reboot (the hardware clock) is already being abused for 
suspend tracing  - 
http://mjmwired.net/kernel/Documentation/power/s2ram.txt .
