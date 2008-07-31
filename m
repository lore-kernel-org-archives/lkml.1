Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYGaHjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYGaHjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbYGaHil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:38:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35517 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYGaHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:38:40 -0400
Date: Thu, 31 Jul 2008 16:38:21 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Switching TestSetPageLocked to trylock_page
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200807311726.51816.nickpiggin@yahoo.com.au>
References: <200807311726.51816.nickpiggin@yahoo.com.au>
Message-Id: <20080731163712.3C90.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm wondering if I could get a patch merged which changes all
> TestSetPageLocked and replaces them with trylock_page?

ACK ACK ACK

I don't read this patch detail.
but it seems good idea.


