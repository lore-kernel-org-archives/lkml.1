Return-Path: <linux-kernel-owner+w=401wt.eu-S935128AbYEBNuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935128AbYEBNuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764960AbYEBNu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:50:26 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:39585 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764945AbYEBNu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:50:26 -0400
Message-ID: <481B1912.6000404@aitel.hist.no>
Date: Fri, 02 May 2008 15:37:22 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
References: <20080430131537.1f7a0914.akpm@linux-foundation.org>	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>	<20080430135405.ddc42075.akpm@linux-foundation.org> <20080430.142137.236846072.davem@davemloft.net>
In-Reply-To: <20080430.142137.236846072.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
[...]
> I guess what these folks are truly afraid of is that someone will
> start tracking reverts and post their results in some presentation
> at some big conference.  I say that would be a good thing.  To
> be honest, hitting the revert button more aggressively and putting
> the fear of being the "revert king" into everyone's minds might
> really help with this problem.
>   
You will probably want to sort by "revert percentage" then.
The absolute number of reverts might make the biggest contributor
"revert king", even if his average patch quality is better than
most.
> Currently there is no sufficient negative pushback on people who
> insert broken crud into the tree.  So it should be no surprise that it
> continues.

Helge Hafting
