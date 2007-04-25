Return-Path: <linux-kernel-owner+w=401wt.eu-S2993038AbXDYUGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993038AbXDYUGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993042AbXDYUGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:06:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993038AbXDYUGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:06:06 -0400
Date: Wed, 25 Apr 2007 13:05:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cbou@mail.ru
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 0/7] Battery class, external power framework, ds2760
 battery
Message-Id: <20070425130501.29a72fa2.akpm@linux-foundation.org>
In-Reply-To: <20070425154820.GA27300@zarina>
References: <20070425154820.GA27300@zarina>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 19:48:20 +0400 Anton Vorontsov <cbou@mail.ru> wrote:

> Andrew, would you please merge these patches into -mm? They're against
> today's Linus git tree.

Not for a while, sorry.  We already have enough material queued for 2.6.22
and a lot of it is broken.  So I am concentrating on fixing the remaining
bugs in 2.6.21 and getting some of the new bugs we have prepared for 2.6.22
fixed up.

Meanwhile, I expect lots of new stuff is appearing in the subsystem trees,
but there isn't much I can do about that.

