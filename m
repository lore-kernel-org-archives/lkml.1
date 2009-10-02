Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbZJBSEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbZJBSEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbZJBSEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:04:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60465
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756878AbZJBSEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:04:44 -0400
Date: Fri, 02 Oct 2009 11:05:04 -0700 (PDT)
Message-Id: <20091002.110504.08207839.davem@davemloft.net>
To: greg@kroah.com
Cc: philipp.reisner@linbit.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, dm-devel@redhat.com,
       zbr@ioremap.net, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/8] SECURITY ISSUE with connector
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091002180022.GA22229@kroah.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
	<20091002.105659.102583702.davem@davemloft.net>
	<20091002180022.GA22229@kroah.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Fri, 2 Oct 2009 11:00:22 -0700

> On Fri, Oct 02, 2009 at 10:56:59AM -0700, David Miller wrote:
>> All applied to net-2.6, I'll push this out to Linus later
>> today.
> 
> Should it also go to -stable?  If so, I can pick it up once it hits
> Linus's tree.

Yes, please take it into -stable.

Greg, I'll also send you a batch of other networking bits
for -stable later this afternoon as well, just FYI...
