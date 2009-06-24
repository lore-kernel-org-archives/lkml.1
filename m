Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbZFXSof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbZFXSof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZFXSoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:44:24 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48291 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZFXSoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:44:23 -0400
Date: Wed, 24 Jun 2009 11:44:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, davem@davemloft.net, dada1@cosmosbay.com,
       zbr@ioremap.net, jeff.chua.linux@gmail.com, paulus@samba.org,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH -tip 0/3] expedited "big hammer" RCU grace periods
Message-ID: <20090624184423.GK6779@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090624164535.GA13334@linux.vnet.ibm.com> <20090624180303.GE7576@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624180303.GE7576@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 08:03:03PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> >  include/linux/rcuclassic.h    |   15 ++-
> 
> heh, we dont have this file anymore ... as of today, right? :)

Ah, I was assuming that expedited RCU would happen before removal of
Classic RCU.

I will respin the expedited RCU patch.  ;-)

							Thanx, Paul
