Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZBKWp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZBKWp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZBKWpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:45:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177AbZBKWps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:45:48 -0500
Date: Wed, 11 Feb 2009 14:45:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: benh@kernel.crashing.org, kosaki.motohiro@jp.fujitsu.com,
       linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmalloc: Add __get_vm_area_caller()
Message-Id: <20090211144509.d22feeb8.akpm@linux-foundation.org>
In-Reply-To: <20090211171804.7021.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090211044854.969CEDDDA9@ozlabs.org>
	<20090211171804.7021.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 17:22:47 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > I want to put into powerpc-next patches relying into that, so if the
> > patch is ok with you guys, can I stick it in powerpc.git ?
> 
> hm.
> Generally, all MM patch should merge into -mm tree at first.
> but I don't think this patch have conflict risk. 
> 
> Andrew, What do you think?

We can sneak it into mainline later in the week?
