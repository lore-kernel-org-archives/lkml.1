Return-Path: <linux-kernel-owner+w=401wt.eu-S934784AbXGYS6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784AbXGYS6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbXGYS60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:58:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757133AbXGYS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:58:25 -0400
Date: Wed, 25 Jul 2007 11:58:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: 2.6.23-rc1-mm1
Message-Id: <20070725115804.5b8efe83.akpm@linux-foundation.org>
In-Reply-To: <200707251323.04594.lenb@kernel.org>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<46A7411C.80202@fr.ibm.com>
	<200707251323.04594.lenb@kernel.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 13:23:04 -0400
Len Brown <lenb@kernel.org> wrote:

> Andrew, you want to re-pull the acpi tree, or do you want me to send
> you some patches on top of the current mm?

I'd appreciate a fix for this one, please - I'll drop it int he hot-fixes
directory as quite a few people seem to be hitting this.
