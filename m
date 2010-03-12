Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0CLRmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:42:51 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37998 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab0CLRmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:42:50 -0500
Date: Fri, 12 Mar 2010 11:42:48 -0600
From: Robin Holt <holt@sgi.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Sony laptop backlight has much coarser steps than a couple years
 ago.
Message-ID: <20100312174248.GA4920@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A long time ago, my laptop (Sony VAIO VGN-FE550G) had xbacklight steps
that were very fine grained and could step down to the point where text
was difficult to read at the edges of the screen.  This was beneficial
for preserving battery life.

An update a couple years ago of something, and I don't recall what,
turned the steps into very coarse steps (1/7).

How would I start going about finding the restriction on the number of
steps and increasing it to a larger value?

Thanks,
Robin Holt
