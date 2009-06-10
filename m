Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbZFJQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbZFJQpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 12:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZFJQpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:45:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52961
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbZFJQpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:45:10 -0400
Date: Wed, 10 Jun 2009 09:45:12 -0700 (PDT)
Message-Id: <20090610.094512.90091251.davem@davemloft.net>
To: jk@ozlabs.org
Cc: patchwork@ozlabs.org, oliver@hartkopp.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/5] can: af_can.c use rcu_barrier() on module unload.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906102241.47823.jk@ozlabs.org>
References: <4A2F6D32.8030400@hartkopp.net>
	<20090610.015245.141342130.davem@davemloft.net>
	<200906102241.47823.jk@ozlabs.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>
Date: Wed, 10 Jun 2009 22:41:47 +1000

> David,
> 
>> We really can't expect patchwork to look for every conceivable
>> malignment of the various reviewer tags.
> 
> No, but we could probably be more tolerant about capitalisation. Any 
> objections about ignoring case completely? I have a patch ready to 
> push...

Sure, sounds fine to me.
