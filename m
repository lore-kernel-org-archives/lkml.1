Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYHKVkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYHKVkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYHKVjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:39:51 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:30741 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYHKVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:39:49 -0400
X-IronPort-AV: E=Sophos;i="4.32,191,1217808000"; 
   d="scan'208";a="94175559"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com,
       kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <adazlnlzc60.fsf@cisco.com>
	<20080809.224637.69833549.davem@davemloft.net>
	<adafxpbzga0.fsf@cisco.com>
	<20080811.140838.202229941.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 11 Aug 2008 14:39:47 -0700
In-Reply-To: <20080811.140838.202229941.davem@davemloft.net> (David Miller's
	message of "Mon, 11 Aug 2008 14:08:38 -0700 (PDT)")
Message-ID: <adahc9rxmcc.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Aug 2008 21:39:48.0006 (UTC) FILETIME=[C70E5460:01C8FBFA]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Yes, that's the question -- are stateless offloads (plus CRC32C in the
 > > CPU etc) going to give good enough performance that the whole TCP
 > > offload exercise is pointless?
 > 
 > This is by definition true, over time.  And this has stedfastly proven
 > itself, over and over again.

By the definition of what?

 - R.
