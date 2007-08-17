Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbXHQKnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbXHQKnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 06:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXHQKnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 06:43:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53406 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbXHQKnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 06:43:03 -0400
Date: Fri, 17 Aug 2007 12:43:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Patrick McHardy <kaber@trash.net>
cc: Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       yasuyuki.kozakai@toshiba.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nf_conntrack_ipv4 must be loaded explicitly
In-Reply-To: <46B22364.9060506@trash.net>
Message-ID: <Pine.LNX.4.64.0708171242450.5492@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708021937140.9319@fbirervta.pbzchgretzou.qr>
 <46B22364.9060506@trash.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 20:33, Patrick McHardy wrote:
>> End result:
>>
>> After loading nf_conntrack_ipv4.ko, everything works again (also with the
>> "bad" ff09b7). But I have to load it explicitly, and I think that
>> unfortunately breaks a lot of setups (such as mine) which assume ipv4
>> connection tracking is always there.
>
> I already have a patch for this queued. I'll push it upstream once
> I get a new power supply for the box I keep that tree on, hopefully
> tommorrow.

What's that patch looking like?



thanks,
	Jan
-- 
