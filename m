Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbXGAXbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbXGAXbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 19:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXGAXbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 19:31:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:56017 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXGAXbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 19:31:23 -0400
In-Reply-To: <4684E7C6.6040300@garzik.org>
References: <Pine.LNX.4.64.0706290012430.15686@blarg.am.freescale.net> <4684E7C6.6040300@garzik.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <FDA9EDFE-8C67-4CFB-91EA-49D07991085F@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, acme@redhat.com
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Please pull from 'from_linus' branch
Date: Sun, 1 Jul 2007 18:31:22 -0500
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

Jeff,

Can you either pull this in your upstream-fixes branch for Linus  
before 2.6.22 comes out.

- k
