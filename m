Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbYG0Abw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbYG0Abw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 20:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYG0Abo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 20:31:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49057
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754447AbYG0Abn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 20:31:43 -0400
Date: Sat, 26 Jul 2008 17:31:43 -0700 (PDT)
Message-Id: <20080726.173143.137065135.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: harvey.harrison@gmail.com, linux-ide@kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: recent IDE regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <200807261404.49947.bzolnier@gmail.com>
References: <20080724.233831.193691312.davem@davemloft.net>
	<200807261404.49947.bzolnier@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Sat, 26 Jul 2008 14:04:49 +0200

> PS We need more big-endian users testing linux-next (this particular patch
> despite being trivial has been put there just-in-case for a week)

Normally I do test linux-next from time to time.

But in the past week or so my efforts have been purely focused on
merging the tree(s) that I maintain.

It's going to be like this for bascially every other person doing
development.

Therefore I would suggest not adding changes during the merge window
that you or someone else has not actually tested.
