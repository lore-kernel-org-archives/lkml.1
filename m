Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYDBP1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYDBP1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYDBP1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:27:38 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:33685 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbYDBP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:27:37 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's in infiniband.git)
References: <adave31bayd.fsf@cisco.com>
	<1207120932.4593.47.camel@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 02 Apr 2008 08:27:36 -0700
In-Reply-To: <1207120932.4593.47.camel@localhost.localdomain> (Shirley Ma's
	message of "Wed, 02 Apr 2008 00:22:12 -0700")
Message-ID: <aday77w2s5z.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Apr 2008 15:27:37.0037 (UTC) FILETIME=[14A59FD0:01C894D6]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What's the status of RDS?

I've never seen any patches.  I guess ask the RDS guys if/when they want
to start working on getting RDS merged.

 - R.
