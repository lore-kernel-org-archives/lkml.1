Return-Path: <linux-kernel-owner+w=401wt.eu-S1762729AbXKNFxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762729AbXKNFxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXKNFxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:53:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55817
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbXKNFxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:53:08 -0500
Date: Tue, 13 Nov 2007 21:53:06 -0800 (PST)
Message-Id: <20071113.215306.78239549.davem@davemloft.net>
To: clameter@sgi.com
Cc: andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711132023290.7631@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711132011060.7528@schroedinger.engr.sgi.com>
	<20071113.201853.40241484.davem@davemloft.net>
	<Pine.LNX.4.64.0711132023290.7631@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 13 Nov 2007 20:26:33 -0800 (PST)

> The only problem that I see so far is a communication problem. Thus
> we need more documentation.

Fair enough, I'll look more closely at the next rev of
your patch set.
