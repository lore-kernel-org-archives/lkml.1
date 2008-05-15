Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbYEOQAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbYEOQAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbYEOQAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:00:00 -0400
Received: from stinky.trash.net ([213.144.137.162]:46013 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082AbYEOP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:59:59 -0400
Message-ID: <482C5DFD.9020602@trash.net>
Date: Thu, 15 May 2008 17:59:57 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Kingsley Foreman <kingsley@internode.com.au>
CC: Jarek Poplawski <jarkao2@gmail.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk>
In-Reply-To: <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kingsley Foreman wrote:
> i just rolled back the kernel to 2.6.24 and im seeing the same thing,
> 
> I was using 2.6.22 before and didn't see the problem, txqueuelen on the 
> bond0 interface is 0 (the default)


Did you also update iproute when moving to a newer kernel?


