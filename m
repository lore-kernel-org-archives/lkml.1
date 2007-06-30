Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbXF3JGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbXF3JGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbXF3JGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:06:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:47919 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbXF3JGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:06:12 -0400
In-Reply-To: <4684E7C6.6040300@garzik.org>
References: <Pine.LNX.4.64.0706290012430.15686@blarg.am.freescale.net> <4684E7C6.6040300@garzik.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1446B1A2-74F8-473D-8439-BCE47E8EF9E3@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, acme@redhat.com
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Please pull from 'from_linus' branch
Date: Sat, 30 Jun 2007 04:06:10 -0500
To: Jeff Garzik <jeff@garzik.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 29, 2007, at 6:06 AM, Jeff Garzik wrote:

> Kumar Gala wrote:
>> Please pull from 'for_linus' branch of
>> 	master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git  
>> for_linus
>> to receive the following updates:
>>  drivers/net/gianfar.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> Kumar Gala (1):
>>       gianfar: Fix typo bug introduced by move to udp_hdr()
>
> Why is net driver stuff no longer going through me?
>
> Fixes are regularly going upstream.

Sorry about that, will push stuff through you in the future.  I've  
sent Linus one off fixes in the past for post -rc issues.

- k
