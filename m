Return-Path: <linux-kernel-owner+w=401wt.eu-S966299AbXDDCec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966299AbXDDCec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966300AbXDDCec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:34:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40292 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966299AbXDDCeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:34:31 -0400
Message-ID: <46130EA4.4000403@pobox.com>
Date: Tue, 03 Apr 2007 22:34:12 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-driver@qlogic.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [-mm patch] make drivers/net/qla3xxx.c:PHY_DEVICES[] static
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070331205540.GB14134@stusta.de>
In-Reply-To: <20070331205540.GB14134@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Mar 30, 2007 at 01:05:59AM -0700, Andrew Morton wrote:
>> ...
>> Changes since 2.6.21-rc5-mm2:
>> ...
>>  git-netdev-all.patch
>> ...
>>  git trees
>> ...
> 
> 
> This patch makes the needlessly global PHY_DEVICES[] static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
> BTW: Why is the name uppercase?

applied


