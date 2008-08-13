Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYHMBCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYHMBCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbYHMBB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:01:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50663
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755625AbYHMBB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:01:57 -0400
Date: Tue, 12 Aug 2008 18:01:59 -0700 (PDT)
Message-Id: <20080812.180159.168355809.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: harvey.harrison@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/22] sparc: use the new byteorder headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080812180052.941c08f6.akpm@linux-foundation.org>
References: <1218587234.30194.92.camel@brick>
	<20080812.174617.81545692.davem@davemloft.net>
	<20080812180052.941c08f6.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Aug 2008 18:00:52 -0700

> On Tue, 12 Aug 2008 17:46:17 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > Date: Tue, 12 Aug 2008 17:27:14 -0700
> > 
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> 
> You should be able to apply this now, if desired.

I would prefer if you merge it as I have a bunch of stuff
already pending in my sparc-2.6 tree and I don't want to
merge in Linus's tree just to apply this one. :-)

