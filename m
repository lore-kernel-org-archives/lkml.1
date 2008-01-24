Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbYAXQJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbYAXQJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYAXQJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:09:23 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:23441 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYAXQJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:09:22 -0500
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.25
X-Message-Flag: Warning: May contain useful information
References: <ada7ii8xaao.fsf@cisco.com>
	<e2e108260801232313r519bd75m9bc26a6fe2e9ebeb@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 Jan 2008 08:09:18 -0800
In-Reply-To: <e2e108260801232313r519bd75m9bc26a6fe2e9ebeb@mail.gmail.com> (Bart Van Assche's message of "Thu, 24 Jan 2008 08:13:20 +0100")
Message-ID: <adahch3nr2p.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Jan 2008 16:09:19.0160 (UTC) FILETIME=[79868B80:01C85EA3]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Anyway, here are all the pending things that I'm aware of.  As usual,
 > > if something isn't already in my tree and isn't listed below, I
 > > probably missed it or dropped it by mistake.  Please remind me again
 > > in that case.
 > 
 > Are there any plans to merge the SDP (Sockets Direct Protocol) implementation ?

No.  To my knowledge, it has never been proposed for merging or been
posted for review.
