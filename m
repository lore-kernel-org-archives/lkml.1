Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYBXA4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYBXA4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 19:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYBXA4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 19:56:41 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54370 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751739AbYBXA4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 19:56:40 -0500
Date: Sun, 24 Feb 2008 01:56:42 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_spi: Fix clock polarity
Message-ID: <20080224015642.53348f75@siona>
In-Reply-To: <20080223000507.3863d71f.akpm@linux-foundation.org>
References: <20080221.111138.41629131.nemoto@toshiba-tops.co.jp>
	<20080223000507.3863d71f.akpm@linux-foundation.org>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 00:05:07 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> I had it queued for 2.6.26 which I guess was wrong.  I'll bump it into
> 2.6.25.

Thanks!

> Is it needed in 2.6.24.x?

I think so. The last time that code was changed was before 2.6.23
AFAICT, so perhaps 2.6.23.x as well.

I'll have a closer look and pass it on to the stable team when it hits
mainline.

Haavard
