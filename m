Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbZFJIwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbZFJIwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbZFJIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:52:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39978
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476AbZFJIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:52:43 -0400
Date: Wed, 10 Jun 2009 01:52:45 -0700 (PDT)
Message-Id: <20090610.015245.141342130.davem@davemloft.net>
To: oliver@hartkopp.net
Cc: patchwork@ozlabs.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] can: af_can.c use rcu_barrier() on module unload.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A2F6D32.8030400@hartkopp.net>
References: <4A2D112A.4000308@hartkopp.net>
	<20090610.011027.43904351.davem@davemloft.net>
	<4A2F6D32.8030400@hartkopp.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Hartkopp <oliver@hartkopp.net>
Date: Wed, 10 Jun 2009 10:22:10 +0200

> David Miller wrote:
>> Otherwise
>> patchwork doesn't pick them up automatically.
> 
> IMHO patchwork should be robust against these type of typos and convert them
> for the users (== your) convenience into 'Acked-by:' ...

We really can't expect patchwork to look for every conceivable
malignment of the various reviewer tags.
