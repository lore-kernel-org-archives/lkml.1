Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZLIOgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZLIOgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZLIOgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:36:46 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:49226 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbZLIOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:36:45 -0500
X-Trace: 303573987/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai4BAKNEH0tQKW/F/2dsb2JhbAAI10mELAQ
X-IronPort-AV: E=Sophos;i="4.47,368,1257120000"; 
   d="scan'208";a="303573987"
Date: Wed, 9 Dec 2009 14:36:42 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: David Miller <davem@davemloft.net>, Ollie Wild <aaw@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
       viro@ftp.linux.org.uk, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
In-Reply-To: <20091209134620.GR14381@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0912091434490.30748@sister.anvils>
References: <20091208060701.GM14381@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0912081142280.31223@sister.anvils> <Pine.LNX.4.64.0912081254500.3365@sister.anvils>
 <20091208.130802.25121122.davem@davemloft.net> <20091208220638.GN14381@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0912091041250.23659@sister.anvils> <20091209134620.GR14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Al Viro wrote:
> 
> Anyway, it's obviously *not* -rc1 fodder at the moment.  So what I'm going
> to do is to leave that one as it is in mainline, push the rest of mmap/mremap
> stuff to Linus later today

Phew, yes, agreed!

Hugh
