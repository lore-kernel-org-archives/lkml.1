Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbZBKXxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbZBKXxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZBKXxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:53:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46548 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbZBKXxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:53:36 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmalloc: Add __get_vm_area_caller()
Cc: kosaki.motohiro@jp.fujitsu.com, benh@kernel.crashing.org,
       linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090211144509.d22feeb8.akpm@linux-foundation.org>
References: <20090211171804.7021.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090211144509.d22feeb8.akpm@linux-foundation.org>
Message-Id: <20090212085156.C8DB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 12 Feb 2009 08:53:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 11 Feb 2009 17:22:47 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > I want to put into powerpc-next patches relying into that, so if the
> > > patch is ok with you guys, can I stick it in powerpc.git ?
> > 
> > hm.
> > Generally, all MM patch should merge into -mm tree at first.
> > but I don't think this patch have conflict risk. 
> > 
> > Andrew, What do you think?
> 
> We can sneak it into mainline later in the week?

I think this patch obiously doesn't have any regression risk.
I obey your judgement.



