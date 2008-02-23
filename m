Return-Path: <linux-kernel-owner+w=401wt.eu-S1763885AbYBWIJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763885AbYBWIJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764848AbYBWIGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:06:08 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761711AbYBWIFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:05:31 -0500
Date: Sat, 23 Feb 2008 00:05:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_spi: Fix clock polarity
Message-Id: <20080223000507.3863d71f.akpm@linux-foundation.org>
In-Reply-To: <20080221.111138.41629131.nemoto@toshiba-tops.co.jp>
References: <20080221.111138.41629131.nemoto@toshiba-tops.co.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 11:11:38 +0900 (JST) Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> This patch is already in mm tree as atmel_spi-fix-clock-polarity.patch.
> I just rewrite description slightly and add my signed-off and acked-by
> from Haavard Skinnemoen.

I had it queued for 2.6.26 which I guess was wrong.  I'll bump it into
2.6.25.  Is it needed in 2.6.24.x?
