Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYIXRQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYIXRQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYIXRQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:16:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:49235 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIXRQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:16:08 -0400
Date: Wed, 24 Sep 2008 10:16:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/3] corruption check: move the corruption checks into
 their own file
Message-ID: <20080924101608.5c99612e@infradead.org>
In-Reply-To: <20080923225306.09fc27b4.akpm@linux-foundation.org>
References: <20080923215335.05678239@infradead.org>
	<20080923225306.09fc27b4.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 22:53:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:


> __init?

I got flamed already for changing code while it's just being moved ....

I'll look at your cleanup suggestions as another separate patch
please ;(

