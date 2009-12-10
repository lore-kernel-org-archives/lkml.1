Return-Path: <linux-kernel-owner+w=401wt.eu-S1762030AbZLJWk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762030AbZLJWk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761999AbZLJWk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:40:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51518
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbZLJWk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:40:56 -0500
Date: Thu, 10 Dec 2009 14:41:02 -0800 (PST)
Message-Id: <20091210.144102.204958821.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: jkosina@suse.cz, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       damian@tvk.rwth-aachen.de, netdev@vger.kernel.org,
       andre.goddard@gmail.com
Subject: Re: linux-next: manual merge of the trivial tree with the
 net-current tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091210221406.94b1aaaf.sfr@canb.auug.org.au>
References: <20091210143756.5a236829.sfr@canb.auug.org.au>
	<alpine.LNX.2.00.0912100944250.3755@pobox.suse.cz>
	<20091210221406.94b1aaaf.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 10 Dec 2009 22:14:06 +1100

> Hi Jiri,
> 
> On Thu, 10 Dec 2009 09:45:27 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrote:
>>
>> Linus has merged trivial tree into his tree tonight, so I am afraid that 
>> davem will have to fix the conflict when pulling Linus tree into 
>> net-current.
> 
> Yep, or Linus can fix it if he feels inclined.

Nah, I'll do a pull into net-2.6 to resolve the conflict first.
