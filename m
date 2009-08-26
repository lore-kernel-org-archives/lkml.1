Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZHZCRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZHZCRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 22:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZHZCRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 22:17:23 -0400
Received: from ozlabs.org ([203.10.76.45]:48797 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZHZCRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 22:17:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Page allocation failures in guest
Date: Wed, 26 Aug 2009 11:47:17 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Avi Kivity <avi@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, netdev@vger.kernel.org
References: <20090713115158.0a4892b0@mjolnir.ossman.eu> <200908121501.53167.rusty@rustcorp.com.au> <20090813222548.5e0743dd@mjolnir.ossman.eu>
In-Reply-To: <20090813222548.5e0743dd@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908261147.17838.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009 05:55:48 am Pierre Ossman wrote:
> On Wed, 12 Aug 2009 15:01:52 +0930
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Subject: virtio: net refill on out-of-memory
... 
> Patch applied. Now we wait. :)

Any results?

Thanks,
Rusty.
