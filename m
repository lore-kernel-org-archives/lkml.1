Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYHaV1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYHaV1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 17:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758043AbYHaV1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 17:27:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:44854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbYHaV1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 17:27:37 -0400
Date: Sun, 31 Aug 2008 14:27:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: post-factum <pfactum@omega.ntu-kpi.kiev.ua>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SKY2 official driver
Message-ID: <20080831142727.4d819b5b@infradead.org>
In-Reply-To: <20080831234345.70d300be@omega.ntu-kpi.kiev.ua>
References: <20080831234345.70d300be@omega.ntu-kpi.kiev.ua>
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

On Sun, 31 Aug 2008 23:43:45 +0300
post-factum <pfactum@omega.ntu-kpi.kiev.ua> wrote:

> Hi to all!
> 
> Please, include official SKY2 ethernet wired network driver from
> Marvell to vanilla Linux kernel. It's less buggy, works more stable
> and is under GPL2.
> 

less buggy than what?

also, the convention on this mailing list is to submit patches rather
than urls, so if you're serious can you please post this in patch
form? Our entire workflow is based on patches that can be code-reviewed
etc etc.

Ideally your patch would just be done as a change to the driver you
claim is more buggy; that way the reviewers can see what you're
changing in this driver...



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
