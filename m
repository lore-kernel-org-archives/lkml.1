Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZA3IfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZA3IfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZA3IfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:35:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbZA3IfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:35:06 -0500
Date: Fri, 30 Jan 2009 00:35:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: Re: [PATCH 1/1] atmel-ssc: fix misuse of dev_dbg when requested ssc
 instance is not found
Message-Id: <20090130003501.ed47dae2.akpm@linux-foundation.org>
In-Reply-To: <20090130092025.618fa78f@hcegtvedt>
References: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
	<20090129174655.1f440f3e@hcegtvedt>
	<20090129155042.e0ea148d.akpm@linux-foundation.org>
	<20090130092025.618fa78f@hcegtvedt>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 09:20:25 +0100 Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:

> > (Suitable cc's added - this was why your patch got lost)
> > 
> 
> AFAICT the lkml is the place for the drivers/misc stuff. Should I be
> looking in another file than MAINTAINERS?

Lots of drivers aren't mentioned in MAINTAINERS.  It is pretty
important to cc the relevant maintainer if poss.  `git whatchanged' is
one way.  Or a bit of inspired guessing (atmel == Haavard, for example).

But the easy way is to cc me - I'll route the thing in the appropriate
direction.

