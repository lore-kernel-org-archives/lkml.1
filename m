Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZIXQSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZIXQSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZIXQSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:18:46 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:61204 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbZIXQSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:18:46 -0400
X-Trace: 262080838/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.36.147/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.36.147
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAJc4u0pPRSST/2dsb2JhbACBUtYrhBsFgks
X-IronPort-AV: E=Sophos;i="4.44,446,1249254000"; 
   d="scan'208";a="262080838"
Date: Thu, 24 Sep 2009 17:18:44 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] ksm: change default values to better fit into mainline
 kernel
In-Reply-To: <4ABB99FE.3060105@redhat.com>
Message-ID: <Pine.LNX.4.64.0909241715260.19324@sister.anvils>
References: <1253736347-3779-1-git-send-email-ieidus@redhat.com>
 <Pine.LNX.4.64.0909241644110.16561@sister.anvils> <4ABB99FE.3060105@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009, Izik Eidus wrote:
> On 09/24/2009 06:52 PM, Hugh Dickins wrote:
> > You rather caught me by surprise with this one, Izik: I was thinking
> > more rc7 than rc1 for switching it off;
> 
> I thought that after the merge window -> only fixes can get in, but I guess I
> was wrong...

Linus much prefers new features in rc1, though sometimes allowed in rc2;
from then on it should be mainly bugfixing, yes, but lots of work does
go in then, and tweaks to defaults, additions to documentation, etc,
are perfectly acceptable.

Hugh
