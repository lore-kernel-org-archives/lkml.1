Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZKSGxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZKSGxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 01:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZKSGxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 01:53:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33874
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbZKSGxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 01:53:15 -0500
Date: Wed, 18 Nov 2009 22:53:32 -0800 (PST)
Message-Id: <20091118.225332.18917545.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: khali@linux-fr.org, bhutchings@solarflare.com, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       mika.kuoppala@nokia.com, linux-i2c@vger.kernel.org
Subject: Re: Shared i2c adapter locking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091118075917.9ac0248c.sfr@canb.auug.org.au>
References: <20091117193313.b750804e.sfr@canb.auug.org.au>
	<20091117103554.03971b2f@hyperion.delvare>
	<20091118075917.9ac0248c.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 18 Nov 2009 07:59:17 +1100

>> If you did and something is still not clear, please let me know. My
>> understanding is that the action token is in David's hands now.
> 
> OK, I will await developments :-)

I just took care of all of this.

Thanks.
