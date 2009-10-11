Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZJKT2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZJKT2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 15:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZJKT2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 15:28:20 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:38377 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZJKT2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 15:28:19 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADHO0UqrR7Hu/2dsb2JhbAC+FpZDhC0E
X-IronPort-AV: E=Sophos;i="4.44,542,1249257600"; 
   d="scan'208";a="406870413"
From: Roland Dreier <rdreier@cisco.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
       infinipath@qlogic.com, Ralph Campbell <ralph.campbell@qlogic.com>
Subject: Re: infiniband BKL leftovers
References: <alpine.LFD.2.00.0910102015400.9428@localhost.localdomain>
	<adad44tj090.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 11 Oct 2009 12:27:42 -0700
In-Reply-To: <adad44tj090.fsf@cisco.com> (Roland Dreier's message of "Sun, 11
	Oct 2009 10:42:19 -0700")
Message-ID: <ada8wfhivdd.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Oct 2009 19:27:42.0522 (UTC) FILETIME=[E712F1A0:01CA4AA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Ralph's direct email]

And the address in MAINTAINERS of infinipath@qlogic.com appears to be
bouncing... so I think it's pretty safe to say that Qlogic doesn't care
too much about the ipath driver any more.

 - R.
