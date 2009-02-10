Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZBJCEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZBJCEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 21:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZBJCEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 21:04:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33231
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbZBJCEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 21:04:16 -0500
Date: Mon, 09 Feb 2009 18:04:09 -0800 (PST)
Message-Id: <20090209.180409.95648545.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       wli@holomorphy.com, akpm@linux-foundation.org
Subject: Re: The mysterious case of struct irqaction's mask field.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200902101223.47313.rusty@rustcorp.com.au>
References: <200902101223.47313.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 10 Feb 2009 12:23:46 +1030

> On the assumption that it has failed to coerce the spirits of our
> ancestors to land among us, I'll create a patch to remove it.

Please do :)
