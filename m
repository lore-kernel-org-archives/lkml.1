Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbXHNITc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbXHNITc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbXHNITT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:19:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49540 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbXHNITR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:19:17 -0400
Date: Tue, 14 Aug 2007 10:19:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: lepton <ytht.net@gmail.com>, lkm <linux-kernel@vger.kernel.org>,
       bcollins@debian.org, linux1394-user@lists.sourceforge.net
Subject: Re: I have two 1394 port in my computer, why did I get only one
 eth1394 interface?
In-Reply-To: <46C0779D.3010401@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0708141017571.30582@fbirervta.pbzchgretzou.qr>
References: <20070813123555.GA6276@router.lepton.home> <46C0779D.3010401@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 13 2007 17:24, Stefan Richter wrote:
>
>>    3. If I must plug my firewire line in some port, can I change the
>> default port to use?
>
>The PHY may have several ports, but all of these ports belong to the same
>FireWire bus. The PHY not only connect the link layer controller with each
>port, it also acts as hub/repeater between those ports.

So given one has two firewire ports with only one PHY, it is not possible
to make a firewall with two interfaces out of it, which each routed only to the
specific firewire port...


	Jan
-- 
