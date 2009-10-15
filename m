Return-Path: <linux-kernel-owner+w=401wt.eu-S935446AbZJOWCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935446AbZJOWCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935373AbZJOWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:02:09 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:39375 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935366AbZJOWCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:02:08 -0400
X-Trace: 274549765/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.3.134/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.3.134
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAAM410pPRQOG/2dsb2JhbACBUtdUhDAE
X-IronPort-AV: E=Sophos;i="4.44,568,1249254000"; 
   d="scan'208";a="274549765"
Date: Thu, 15 Oct 2009 23:01:29 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/9] swap_info: miscellaneous minor cleanups
In-Reply-To: <20091015111924.01c6b36f.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0910152256460.4447@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
 <Pine.LNX.4.64.0910150149160.3291@sister.anvils>
 <20091015111924.01c6b36f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> On Thu, 15 Oct 2009 01:50:54 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> 
> > Move CONFIG_MIGRATION's swapdev_block() into the main CONFIG_MIGRATION
> > block, remove extraneous whitespace and return, fix typo in a comment.
> > 
> CONFIG_HIBERNATION ?

Absolutely!  Thanks a lot for spotting that (and for reviewing all these,
so quickly).  It seems I'm confused by birds migrating for the winter :)
A 4/9 v2, correcting just that comment, will follow when I've gone
through your other suggestions.

Hugh
