Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYIKEA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYIKEA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 00:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbYIKEAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 00:00:18 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:32985 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYIKEAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 00:00:17 -0400
Message-ID: <48C897C3.10100@davidnewall.com>
Date: Thu, 11 Sep 2008 13:30:03 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dwmw2@infradead.org, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
References: <48C68507.6000609@suse.com>	<1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net>
In-Reply-To: <20080910.160505.14060698.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
>   
>> Firmware really _isn't_ version-specific.
>>     
>
> Tell that to every Debian and Debian derived system on the planet.


And a damned nuisance it is, too.  Firmware *really* isn't kernel
version-specific, and I'd like Debian to "get" that.
