Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbYGPKJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbYGPKJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbYGPKI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:08:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40086
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbYGPKI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:08:58 -0400
Date: Wed, 16 Jul 2008 03:08:57 -0700 (PDT)
Message-Id: <20080716.030857.261411379.davem@davemloft.net>
To: pageexec@freemail.hu
Cc: tiago@assumpcao.org, torvalds@linux-foundation.org, greg@kroah.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
From: David Miller <davem@davemloft.net>
In-Reply-To: <487DE059.15123.1EBDA558@pageexec.freemail.hu>
References: <487D4A7B.8090403@assumpcao.org>
	<alpine.LFD.1.10.0807151832260.2835@woody.linux-foundation.org>
	<487DE059.15123.1EBDA558@pageexec.freemail.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: pageexec@freemail.hu
Date: Wed, 16 Jul 2008 11:49:45 +0200

> why? what makes you think that a bug fixed in 2.6.26 is not relevant to
> 2.6.20? do you or anyone else personally verify that? color me impressed
> if you do that on every single fix you commit.

Many people who do kernel development do exactly this for the vendor
they work for.

The SCTP socket option overflow fix got into various dist releases not
by chance and not because of some utterly pointless "security" tag in
the commit message.


