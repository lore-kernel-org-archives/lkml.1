Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbZDOKot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbZDOKot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZDOKoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:44:32 -0400
Received: from stinky.trash.net ([213.144.137.162]:56184 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700AbZDOKo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:44:29 -0400
Message-ID: <49E5BA83.2010602@trash.net>
Date: Wed, 15 Apr 2009 12:44:19 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: panic on rmmod of nf_conntrack_irc
References: <20090410191736.21efab8c@mako-desktop> <49E4744D.5090205@trash.net> <49E47C2D.1050508@cosmosbay.com> <49E5B66D.30602@trash.net> <49E5BA13.7000501@cosmosbay.com>
In-Reply-To: <49E5BA13.7000501@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Patrick McHardy a écrit :
>> Eric, on second thought, could you please resubmit this to Dave?
>> It touches too many files outside of netfilter to go through my
>> tree.
> 
> Sure, but its a cleanup (and was an RFC to show my point)
> so should wait a litle bit until David opens his -next tree (for 2.6.31)

Fine with me :)

> Please just submit your patch for 2.6.30 ?

OK, I'll do that.
