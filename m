Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYJZHlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYJZHlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 03:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYJZHk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 03:40:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46329 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYJZHk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 03:40:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49041EF1.8070508@s5r6.in-berlin.de>
Date: Sun, 26 Oct 2008 08:40:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au>
In-Reply-To: <20081026005009.50dbbb33.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> The following is an approximate list of commits left in linux-next
> relative to 2.6.28-rc1.
...
> ieee1394
> 
> 	David Moore (1):
> 	      firewire: Include iso timestamp in headers when header_size > 4
> 
> 	Jay Fenlason (2):
> 	      firewire: add a client_list_lock
> 	      firewire: Survive more than 256 bus resets
> 
> 	Stefan Richter (2):
> 	      firewire: fw-sbp2: extend failure check after SCSI probe
> 	      firewire: convert client_list_lock to mutex

1x new fix for a pull request soon
1x obsoleted by belated info from a problem reporter
3x things which turned out unfit for -next pre 2.6.28-rc1 but I was too
    lazy to temporarily revert in my for-next branch
-- 
Stefan Richter
-=====-==--- =-=- ==-=-
http://arcgraph.de/sr/
