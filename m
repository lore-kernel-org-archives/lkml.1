Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbYF2OaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbYF2OaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 10:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbYF2O3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 10:29:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55613 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759539AbYF2O3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 10:29:37 -0400
Date: Sun, 29 Jun 2008 16:29:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Pavel Machek <pavel@suse.cz>
cc: Willy Tarreau <w@1wt.eu>, Xose Vazquez Perez <xose.vazquez@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com
Subject: Re: AdvFS released under GPLv2
In-Reply-To: <20080626151115.GL5642@ucw.cz>
Message-ID: <alpine.LNX.1.10.0806261816370.12725@fbirervta.pbzchgretzou.qr>
References: <ee588a540806230519h1f09498ev655be6c6e32e6f5@mail.gmail.com> <20080623124929.GA1369@1wt.eu> <20080626151115.GL5642@ucw.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-06-26 17:11, Pavel Machek wrote:
>
>> > HP has released AdvFS, a file system that was developed by Digital
>> > Equipment Corp
>> > and continues to be part of HP's Tru64 operating system.
>> 
>> Wow! That's awesome. I discovered it in 1999 and 9 years later, it probably
>> remains the most advanced FS I encountered. That was a major reason I was
>> sad to see Digital Unix die.
>
>That's something I missed in the press release... what is so advanced
>about AdvFS? What is the killer feature?

Automatic storage pool resizing would be the killer feature I would want.
Especially advanced Windows users (yes, well, that's my observation)
tend to create lots and lots of partitions and of course having one
filled up means you either need to improvise or undertake a partition
resizing (the latter of which is always a bit risky).
