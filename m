Return-Path: <linux-kernel-owner+w=401wt.eu-S1763310AbXERSbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763310AbXERSbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbXERSbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:31:48 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:47334 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbXERSbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:31:48 -0400
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
In-reply-to: <20070518105318.ae611edc.akpm@linux-foundation.org> (message from
	Andrew Morton on Fri, 18 May 2007 10:53:18 -0700)
Subject: Re: [patch] fix unused setup_nr_node_ids
References: <E1Hozre-0003rZ-00@dorka.pomaz.szeredi.hu> <20070518105318.ae611edc.akpm@linux-foundation.org>
Message-Id: <E1Hp7Dg-0004lK-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 May 2007 20:30:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That doesn't do much to inprove overall readability.
> 
> I suspect the warning was only there because the stubbed version of
> setup_nr_node_ids() forgot to be declared static inline, yes?
> 
> How about this?

Yes, looks good.

Thanks,
Miklos
