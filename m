Return-Path: <linux-kernel-owner+w=401wt.eu-S934266AbXHVRXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbXHVRXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933905AbXHVRVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:21:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46704 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933899AbXHVRVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:21:46 -0400
Date: Wed, 22 Aug 2007 21:24:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcin Kowalczyk <qrczak@knm.org.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] setpgid(child) fails if the child was forked by sub-thread
Message-ID: <20070822172436.GA1635@tv-sign.ru>
References: <bug-8921-10286@http.bugzilla.kernel.org/> <20070822082517.321edfa5.akpm@linux-foundation.org> <20070822165539.GA191@tv-sign.ru> <20070822100802.c2c202f9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822100802.c2c202f9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Randy Dunlap wrote:
>
> On Wed, 22 Aug 2007 20:55:39 +0400 Oleg Nesterov wrote:
> 
> 
> so "fixes http://bugzilla.kernel.org/show_bug.cgi?id=8921"  ??

Hopefully yes... should I add some note at /bugzilla.kernel.org?

Oleg.

